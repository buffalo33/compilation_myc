all		:	lang

y.tab.h y.tab.c :	src/lang.y
			bison -v -y  -d  src/lang.y
lex.yy.c	:	src/lang.l y.tab.h
			flex src/lang.l 
lang		:	lex.yy.c y.tab.c src/Table_des_symboles.c src/Table_des_chaines.c src/Attribute.c
			gcc -g -o myc lex.yy.c y.tab.c src/Attribute.c src/Table_des_symboles.c src/Table_des_chaines.c
clean		:	
			rm -f 	lex.yy.c *.o y.tab.h y.tab.c lang *~ y.output myc
