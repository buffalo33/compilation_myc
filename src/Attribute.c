#include "Attribute.h"

#include <stdlib.h>
#include "Table_des_symboles.h"

int makeNum(){
  static int n = 0;
  return ++n;
}


static int lbl = 0;

int makeLabel(){
  return ++lbl;
}



int unmakeLabel(){
  return --lbl;
  }

int getLabel(){
  return lbl;
}


attribute new_attribute () {
  attribute r;
  r  = malloc (sizeof (struct ATTRIBUTE));
  return r;    
};




/* attribute plus_attribute(attribute x, attribute y) { */
/*   attribute r = new_attribute(); */
/*   /\* unconditionally adding integer values *\/ */
/*   r -> int_val = x -> int_val + y -> int_val; */
/*   return r; */
/* }; */

/* attribute mult_attribute(attribute x, attribute y){ */
/*   attribute r = new_attribute(); */
/*   /\* unconditionally adding integer values *\/ */
/*   r -> int_val = x -> int_val * y -> int_val; */
/*   return r; */
/* }; */

/* attribute minus_attribute(attribute x, attribute y){ */
/*   attribute r = new_attribute(); */
/*   /\* unconditionally adding integer values *\/ */
/*   r -> int_val = x -> int_val - y -> int_val; */
/*   return r; */
/* }; */

/* attribute div_attribute(attribute x, attribute y){ */
/*   attribute r = new_attribute(); */
/*   /\* unconditionally adding integer values *\/ */
/*   r -> int_val = x -> int_val % y -> int_val; */
/*   return r; */
/* }; */

/* attribute neg_attribute(attribute x){ */
/*   attribute r = new_attribute(); */
/*   /\* unconditionally adding integer values *\/ */
/*   r -> int_val = -(x -> int_val); */
/*   return r; */
/* }; */
/* *\/ */
