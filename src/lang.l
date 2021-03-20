%option noyywrap
/* avoid dependency with library fl */

%{ 
#include "y.tab.h"
#include "src/Table_des_symboles.h"
#include "src/Attribute.h"
#include <stdio.h>

%} 
%% 

"="                      { return EQ;}

"+"                      { return PLUS;}
"-"                      { return MOINS;}
"*"                      { return STAR;}
"/"                      { return DIV;}
"||"                     { return OR;}
"&&"                     { return AND;}
"!"                      { return NOT;}

"&"                      {return ESP;}

"=="                     { return EQUAL;}
"!="                     { return DIFF;}
"<"                      { return INF;}
">"                      { return SUP;}

"("                      { return PO;}
")"                      { return PF;}
"{"                      {
enter_block();
printf("{\n");
                          return AO;}
"}"                      {
exit_block();
printf("}\n");
                           return AF;}

"int"                    { return TINT;}

"return"                 {return RETURN;}
"void"                   { return VOID;}
"if"                     { return IF;}
"else"                   { return ELSE;}
"while"                  { return WHILE;}

"."                      { return DOT;}
"->"                     { return ARR;}

";"                      { return PV;}
","                      { return VIR;}


[0-9]+                   { yylval.val = new_attribute("");
                           yylval.val->reg_number = makeNum();
                           yylval.val -> type_val = INT;
                           yylval.val -> name =  yytext;
                           printf("int r%d = %s;\n", yylval.val->reg_number, yylval.val->name);
                           return NUMI; }
[A-Za-z][A-Za-z0-9]*     {

yylval.val = new_attribute();
if (get_symbol_value(string_to_sid(yytext)) != NULL){
yylval.val = get_symbol_value(string_to_sid(yytext));
}
else{
yylval.val->name = string_to_sid(yytext);
}
return ID;
}

[ \t\n]                   { /* on avale sans rendre la main */; }
