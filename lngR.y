%{
#include <stdio.h>
#include <string.h>
#include "sem.h"
#include "TS.h"

extern FILE * yyin;
//extern ts;

extern unsigned short line, column;
extern unsigned short errors;
extern int yyleng;

char indice;
%}

%union{
	int entier;
	float decimal;
	char * entite;
	char caractere;
}

%token <entite> IDENTIFIER
%token <entier> INTEGER
%token <decimal> NUMERIC //FLOAT
%token <caractere> CHARACTER
%token <entite> LOGICAL

%type <caractere> type

%token TYPE_INTEGER TYPE_NUMERIC TYPE_CHAR TYPE_LOGICAL //numeric -> float
%token AFF OPEN_ACO CLOSE_ACO OPEN_BRACE CLOSE_BRACE DOUBLE_DOT COMMA ENTER
%token FOR IN WHILE IF ELSE IFELSE

%left OPEN_PARENT CLOSE_PARENT
%left AND
%left OR
%left SUP_EG INF_EG EG NOT_EG SUP INF
%left PLUS MINUS
%left STAR SLASH MODULO

%start S

%%

S : code | declaration | code S | declaration S
;
type : TYPE_INTEGER {indice = 'I';} | TYPE_NUMERIC {indice = 'N';} | TYPE_CHAR {indice = 'C';} | TYPE_LOGICAL {indice = 'L';};
declaration : type dec_variable ENTER | type dec_vector ENTER
;
dec_variable : dec_var1 | dec_var2;
dec_var1 : IDENTIFIER  {declaration_variable($1, indice, 'V', 1);} | IDENTIFIER COMMA dec_var1 {declaration_variable($1, indice, 'V', 1);};
dec_var2 : IDENTIFIER AFF values; //type
dec_vector : IDENTIFIER OPEN_BRACE INTEGER CLOSE_BRACE; //check INTEGER

values : val | CHARACTER | LOGICAL
;

code : instruction code | instruction; 
instruction : assignment ENTER | inst_if ENTER | inst_for ENTER | inst_while ENTER | increment ENTER | decrement ENTER
;
increment : IDENTIFIER PLUS AFF INTEGER; //check INTEGER
decrement : IDENTIFIER MINUS AFF INTEGER; //check INTEGER

inst_if : IF logic_expression ENTER OPEN_ACO ENTER code CLOSE_ACO
		| IF logic_expression ENTER OPEN_ACO ENTER code CLOSE_ACO inst_else;
inst_else : ELSE ENTER OPEN_ACO ENTER code CLOSE_ACO
		| ELSE inst_if
		;

inst_while : WHILE logic_expression ENTER OPEN_ACO ENTER code CLOSE_ACO
;
assignment : IDENTIFIER AFF values | IDENTIFIER AFF arith_expression | IDENTIFIER AFF logic_expression
;
inst_for : FOR OPEN_PARENT IDENTIFIER IN INTEGER DOUBLE_DOT INTEGER CLOSE_PARENT ENTER OPEN_ACO ENTER code CLOSE_ACO
;

logic_expression : condition | condition AND logic_expression | condition OR logic_expression
;

operation : PLUS | MINUS | STAR | SLASH | MODULO;
val : INTEGER | NUMERIC | IDENTIFIER;
arith_expression : val | val operation arith_expression | OPEN_PARENT arith_expression CLOSE_PARENT
;

comp_operation : SUP_EG  | INF_EG  | EG | NOT_EG | SUP | INF;
condition : OPEN_PARENT arith_expression comp_operation arith_expression CLOSE_PARENT
;

%%
int yyerror(char * message){
	errors++;
	printf("Erreur syntaxique : ligne %u colonne %u : %s\n", line, column, yylval.entite);
	return 1;
}
int main(int argc, char * argv[]){

	printf("\nAnalyse lexical & syntaxique du fichier... \n\n\n");
	
	yyin = fopen("test.txt","r");
	
	yyparse();
	if(errors==0) printf("Analyse terminee. Aucune erreur n'est trouvee.\n");

	afficher();
	afficher_quadr();

	fclose(yyin);
	 
	system("pause");
	return 0;
}