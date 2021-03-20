/*
 *  Attribute.h
 *
 *  Created by Janin on 10/2019
 *  Copyright 2018 LaBRI. All rights reserved.
 *
 *  Module for a clean handling of attibutes values
 *
 */

#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H

#define TAB_SIZE 255

typedef enum {INT, POINTER, VOIDD, FRAME, FLOAT} type;

typedef struct ATTRIBUTE * attribute;

struct ATTRIBUTE {
  char * name; //Utilise par : ID
  type type_val;//Utilise par : NUMI, NUMP, TINT,typename, type , exp, bool_cond, app
  int reg_number;//Utilise par :ID, exp, bool_cond, ret, app
  attribute tab[TAB_SIZE]; //Utilise par : vlist, var_decl, decl ,arglist, args, params
  int size_tab;
  int lbl; //IF, WHILE
  //int lbl2; //ELSE
  int nb_star;

  /*name est le nom pour des identifiants*/

  /*int_val est la valeur d'attribut pour un entier*/
  
  /*point_val, fonctionne comme int_val, mais pour la valeur des pointeur*/

  /*type_val est le type*/

  /*reg_number est le numero de registre dans lequelle est stocké l'attribut*/
  
  /*Le parametre "tab" sert a stocker des tableaux d' ATTRIBUTE, dans le cadre d'une liste de variables par exemple.*/


  

};



attribute new_attribute ();
/* returns the pointeur to a newly allocated (but uninitialized) attribute value structure */


attribute plus_attribute(attribute x, attribute y);
attribute mult_attribute(attribute x, attribute y);
attribute minus_attribute(attribute x, attribute y);
attribute div_attribute(attribute x, attribute y);
attribute neg_attribute(attribute x);

int makeNum();
int makeLabel();
int unmakeLabel();
int getLabel();

#endif

