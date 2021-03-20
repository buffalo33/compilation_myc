/*
 *  Table des symboles.c
 *
 *  Created by Janin on 12/10/10.
 *  Copyright 2010 LaBRI. All rights reserved.
 *
 */

#include "Table_des_symboles.h"
#include "Attribute.h"

#include <stdlib.h>
#include <stdio.h>

/* The storage structure is implemented as a linked chain */

/* linked element def */

typedef struct elem {
	sid symbol_name;
	attribute symbol_value;
	struct elem * next;
} elem;

/* linked chain initial element */
static elem * storage=NULL;

/* get the symbol value of symb_id from the symbol table */
attribute get_symbol_value(sid symb_id) {
	elem * tracker=storage;

	/* look into the linked list for the symbol value */
	while (tracker) {
		if (tracker -> symbol_name == symb_id) return tracker -> symbol_value; 
		tracker = tracker -> next;
	}
    
	/* if not found does cause an error */
	//fprintf(stderr,"Error : symbol %s is not a valid defined symbol\n",(char *) symb_id);
	//exit(-1);
	return NULL;
};

/* set the value of symbol symb_id to value */
attribute set_symbol_value(sid symb_id,attribute value) {

	elem * tracker;
	
	/* look for the presence of symb_id in storage */
	
	tracker = storage;
	while ((tracker != NULL) && (tracker->symbol_value->type_val != FRAME)){
		if (tracker -> symbol_name == symb_id) {
		  tracker -> symbol_value = value;
		  return tracker -> symbol_value;
		}
		tracker = tracker -> next;
	}
	
	/* otherwise insert it at head of storage with proper value */
	
	tracker = malloc(sizeof(elem));
	tracker -> symbol_name = symb_id;
	tracker -> symbol_value = value;
	tracker -> next = storage;
	storage = tracker;
	return storage -> symbol_value;
}

void enter_block()
{
  sid frame_sid = string_to_sid("frame");
  attribute frame = new_attribute();
  frame->type_val = FRAME;
  set_symbol_value(frame_sid,frame);
  int size = 0;
}

void exit_block()
{
  elem* tracker = storage;
  while (tracker != NULL && tracker->symbol_value->type_val != FRAME)
    {
      tracker = tracker->next;
    }
  storage = tracker->next;

  /*  int size = 0;
  for(tracker = tracker->next; tracker != NULL && size++ != -666 && printf("//elem: %s\n", string_to_sid(tracker->symbol_value->name)) ; tracker = tracker->next);
  printf("//size à la sortie: %d\n", size);      */
}