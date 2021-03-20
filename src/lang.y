%{

#include "src/Table_des_symboles.h"
#include "src/Attribute.h"

#include <stdio.h>
  
extern int yylex();
extern int yyparse();

void yyerror (char* s) {
  printf ("%s\n",s);
  }
		

%}

%union { 
	struct ATTRIBUTE * val;
}
%token <val> NUMI NUMF NUMP  
%token TINT // TFLOAT STRUCT
%token <val> ID
%token AO AF PO PF PV VIR
%token RETURN VOID EQ
%token <val> IF ELSE WHILE

%token <val> AND OR NOT DIFF EQUAL SUP INF
%token PLUS MOINS STAR DIV
%token DOT ARR
%token ESP

%nterm <val> exp
%nterm <val> while_cond
%nterm <val> bool_cond
%nterm <val> while
%nterm <val> else
%nterm <val> elsop

%nterm <val> type
%nterm <val> pointer
%nterm <val> var_decl
   
%left DIFF EQUAL SUP INF       // low priority on comparison
%left PLUS MOINS               // higher priority on + - 
%left STAR DIV                 // higher priority on * /
%left OR                       // higher priority on ||
%left AND                      // higher priority on &&
%left DOT ARR                  // higher priority on . and -> 
%nonassoc UNA                  // highest priority on unary operator
%nonassoc then
%nonassoc ELSE

   
%start prog  
 


%%

prog : func_list               {}
;

func_list : func_list fun      {}
| fun                          {}
;


// I. Functions

fun : type fun_head fun_body        {
 }
;

fun_head : ID PO PF            {printf("%s()", $1->name);}
| ID PO params PF              {printf("%s", $1->name);}
;

params: type ID vir params     {}
| type ID                      {}

vlist: vlist vir ID            {
  attribute copy = new_attribute();
  *(copy) = *($3);
  set_symbol_value(copy->name, copy);
  copy->type_val = ($<val>0->nb_star > 0);
  copy->nb_star = $<val>0->nb_star;
  printf("%s", $3->name);
 }
| ID                           {
  attribute copy = new_attribute();
  *(copy) = *($1);
  set_symbol_value(copy->name, copy);
  copy->type_val = ($<val>0->nb_star > 0);
  copy->nb_star = $<val>0->nb_star;
  printf("%s", $1->name);
 }
;

vir : VIR                      {printf(", ");}
;

fun_body : AO block AF         {}
;

// Block
block:
decl_list inst_list            {}
;

// I. Declarations

decl_list : decl_list decl     {}//new fp ici
|                              {}
;

decl: var_decl PV              {}
;

var_decl : type vlist          {
  $$ = $1;
  printf(";\n");}

type
: typename pointer             {$$ = $2;
}
| typename                     {$$ = new_attribute("");
  $$->nb_star = 0;}
;

typename
: TINT                          {printf("int ");}
| VOID                          {printf("void ");}
;

pointer
: pointer STAR                 {
  $$ = new_attribute("");
  $$->nb_star = $1->nb_star + 1;
  printf("*");
}
| STAR
{
  $$ = new_attribute("");
  $$->nb_star = 1;
  printf("*");
}
;


// II. Intructions

inst_list: inst PV inst_list {}
| inst pvo                   {}
;

pvo : PV
|
;


inst:
exp                           {}//printf("instr detectee exp\n");}
| AO block AF                 {}//printf("instr detectee block\n");}
| aff                         {}//printf("instr detectee aff\n");}
| ret                         {}//printf("instr detectee ret\n");}
| cond                        {}//printf("instr detectee cond\n");}
| loop                        {}//printf("instr detectee loop\n");}
| PV                          {//printf(";\n");
                               }//printf("instr detectee PV\n");}
;


// II.1 Affectations

aff : ID EQ exp               {printf("%s = r%d;\n", $1->name, $3->reg_number);}
| STAR exp  EQ exp
| ID EQ ESP exp              {
  printf("%s = &%s;\n", $1->name, $4->name);}

// II.2 Return
ret : RETURN exp              {printf("return r%d;\n",$2->reg_number);}
| RETURN PO PF                {printf("return 0;\n");}
;

// II.3. Conditionelles
//           N.B. ces rêgles génèrent un conflit déclage reduction qui est résolu comme on le souhaite
//           i.e. en lisant un ELSE en entrée, si on peut faire une reduction elsop, on la fait...

cond :
if bool_cond inst elsop       {}
;

elsop : else inst             {printf("end_if%d:\n;\n", $<val>-1->lbl);}
|                             {printf("beg_else%d:\n;\n", $<val>-1->lbl);} %prec then
;

bool_cond : PO exp PF         {
  $$ = new_attribute("");
  $$->lbl = makeLabel();
  printf("if (!r%d) goto beg_else%d;\n",$2->reg_number,$$->lbl);
}
;

if : IF                       {}
;

 else : ELSE                   {
   $$ = new_attribute("");
   $$->lbl = $<val>-1->lbl;
   printf("goto end_if%d;\nbeg_else%d:\n", $$->lbl, $$->lbl);}//stocker label
;

// II.4. Iterations

loop : while while_cond inst  {printf("goto beg_while%d;\n end_while%d:\n;\n",$2->lbl,$2->lbl);}
;

while_cond : PO exp PF  {
  $$ = new_attribute("");
  $$->lbl = $<val>0->lbl;
  printf("if (!r%d) goto end_while%d;\n",$2->reg_number, $$->lbl);}//recuperer le label dans $0

while : WHILE                 {$$ = new_attribute("");
                               $$->lbl = makeLabel();
                               printf("beg_while%d:\n;\n",$$->lbl);}
;


// II.3 Expressions
exp
// II.3.0 Exp. arithmetiques
: MOINS exp %prec UNA         {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = - r%d;\n", $$->reg_number, $2->reg_number);
}
| exp PLUS exp                {

  char* str = "\0";
  //  char* cast = "\0";
  if ($1->type_val == POINTER){
    str = malloc(sizeof(char) * ($1->nb_star + 1));
    for (int i = 0; i < $1->nb_star; str[i++] = '*');
    str[$1->nb_star] = '\0';
    //    cast =
  }
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int %s r%d = r%d + r%d;\n", str, $$->reg_number, $1->reg_number, $3->reg_number);

  if ($1->type_val == POINTER){
    free(str);
  }

}
| exp MOINS exp               {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d - r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
 }
| exp STAR exp                {
   $$ = new_attribute("");
   $$->reg_number = makeNum();
   printf("int r%d = r%d * r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
 }
| exp DIV exp                 {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d / r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
 }
| PO exp PF                   {$$ = $2;}
| ID                          {
  $$ = $1;
  char* str = "\0";  
  str = malloc(sizeof(char) * ($$->nb_star + 1));
  for (int i = 0; i < $1->nb_star; str[i++] = '*');
  str[$$->nb_star] = '\0';
  yylval.val->reg_number = makeNum();
  printf("int%s r%d = %s;\n", str, $$->reg_number, $$->name);
  free(str);
}
| app                         {}
| NUMI                        {$$ = $1;}
//| NUMF                        {$$ = $1;}

// II.3.1 Déréférencement

| STAR exp %prec UNA          {}

// II.3.2. Booléens

| NOT exp %prec UNA           {}
| exp INF exp                 {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d <= r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
}
| exp SUP exp                 {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d >= r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
}
| exp EQUAL exp               {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d == r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);}
| exp DIFF exp                {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d != r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
}
| exp AND exp                 {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d && r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);
}
| exp OR exp                  {
  $$ = new_attribute("");
  $$->reg_number = makeNum();
  printf("int r%d = r%d && r%d;\n", $$->reg_number, $1->reg_number, $3->reg_number);}

;

// II.4 Applications de fonctions

app : ID PO args PF;

args :  arglist               {}
|                             {}
;

arglist : exp VIR arglist     {}
| exp                         {}
;



%% 
int main () {
  return yyparse ();
} 

