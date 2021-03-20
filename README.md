Projet de construction d'un compilateur de langage pseudo-C.
==============================================================

Contexte :
----------
Bonjour, vous vous trouvez dans ce dépôt du projet de compilation de Préaut Clément et Gauchet Augustin. Ce projet utilise Lex et YACC. Il permet de compiler (traduire) plusieurs un langage pseudo-C en langage trois adresse, en C. Ce langague compilé est donc lui m-ême compilable par la suite avec gcc.

Fonctionnalités du compilateur :
Ce compilateur est capable de compiler un langage possédant les aspects suivants :
1. un mécanisme de déclarations explicite de variables.
2. des expresssion arithmétiques arbitraire de type calculatrice.
3. des lectures ou écritures mémoires via des affectations avec variables utilisateurs ou pointeurs.
4. des structures de contrôles classiques (conditionelles et boucles).
5. un mécanisme de typage simple comprenant notamment des entiers int et des pointeurs int *.


Instructions :
--------------

`make` : Compile le projet

`./compil.sh <nom_fichier>` : execute le compilateur sur <nom_fichier>.myc, génère le code C 3 adresses sous la forme <nom_fichier>.c, et affiche son contenu à l'écran. Le script compile ensuite ce fichier C.

Arguments à tester : test et test_simple. Ces fichier sont dans le répertoire tests
Pour compiler notre compilateur, entrez la commande "make" dans votre terminal.

Notes :

Les variables déclarées dans les blocs sont bien des variables locales au bloc, grâce à l'utilisation de frame pointers dans une pile de symbole, dont on définit le comportement dans Table_des_symboles.c.

En ce qui concerne les blocs conditionnels, nous souhaitons obtenir les résultats de compilations suivants:

if r inst -> if !r goto beg_else;
	     inst;
	     beg_else:

if r inst1 else inst2 -> if !r goto beg_else;
     	   	      	 inst1;
			 goto end_if;
			 beg_else:
			 inst2;
			 end_if:
