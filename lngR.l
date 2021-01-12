%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "TS.h"

#include "lngR.tab.h"
extern YYSTYPE yylval;

unsigned short line = 1;
unsigned short column = 1;
unsigned short errors = 0;

%}

INTEGER 0|[1-9][0-9]*|\([-+][0-9]+\)
    // 0 15 (+172) (-22) ...
NUMERIC ((0|[1-9][0-9]*)\.[0-9]+)|\([-+][0-9]+\.[0-9]+\)
    // 0.521 (+3.0) (-193.56) ...

CHARACTER \'.\'
    // 'H' '5' ...
LOGICAL TRUE|FALSE

TYPE INTEGER|NUMERIC|CHARACTER|LOGICAL

IDENTIFIER [A-Z][a-z0-9]{0,10}  
    // Compil Tp5 ...

%%

{INTEGER} {
	long int entier; 
	if(yytext[0]=='(') entier = strtol(yytext+1, NULL, 10); // Si le 1er caractère est le ( alors commencer la convertion de +/- (Position n°1)
	else entier = strtol(yytext, NULL, 10); // Sinon, convertir toute l'entité
	if(entier >= -32768 && entier <= 32767){
		column+=yyleng;
		yylval.entier = entier;
		return INTEGER;
	}
	else fprintf(stderr, "Dépassement de capacité : ligne %d colonne %d : %s\n", line, column, yytext);
}

{NUMERIC} {
	double decimal;
	if(yytext[0]=='(') decimal = strtod(yytext+1, NULL); // Si le 1er caractère est le ( alors commencer la convertion de +/- (Position n°1)
	else decimal = strtod(yytext, NULL); // Sinon, convertir toute l'entité
	column+=yyleng;
	yylval.decimal = decimal;
	return NUMERIC;
}

{CHARACTER} {
	column+=yyleng;
	yylval.entite = yytext;
	return CHARACTER;
}

{LOGICAL} {
	column+=yyleng;
	yylval.entite = yytext;
	return LOGICAL;
}

{TYPE} {
	column+=yyleng;
	yylval.entite = yytext;
	if(!strcmp(yytext,"INTEGER")) return TYPE_INTEGER;
	else if(!strcmp(yytext,"NUMERIC")) return TYPE_NUMERIC;
	else if(!strcmp(yytext,"CHARACTER")) return TYPE_CHAR;
	else if(!strcmp(yytext,"LOGICAL")) return TYPE_LOGICAL;
}

{IDENTIFIER} {
	column+=yyleng;
	yylval.entite = yytext;
	return IDENTIFIER;
}


AND {
	column+=yyleng;
	yylval.entite = yytext;
	return AND;
}
OR {
	column+=yyleng;
	yylval.entite = yytext;
	return OR;
}


"+" {
	column+=yyleng;
	yylval.entite = yytext;
	return PLUS;
}
"-" {
	column+=yyleng;
	yylval.entite = yytext;
	return MINUS;
}
"*" {
	column+=yyleng;
	yylval.entite = yytext;
	return STAR;
}
"/" {
	column+=yyleng;
	yylval.entite = yytext;
	return SLASH;
}
"%" {
	column+=yyleng;
	yylval.entite = yytext;
	return MODULO;
}


"<" {
	column+=yyleng;
	yylval.entite=yytext;
	return INF;
}
">" {
	column+=yyleng;
	yylval.entite=yytext;
	return SUP;
}
"<=" {
	column+=yyleng;
	yylval.entite=yytext;
	return INF_EG;
}
">=" {
	column+=yyleng;
	yylval.entite=yytext;
	return SUP_EG;
}
"==" {
	column+=yyleng;
	yylval.entite=yytext;
	return EG;
}
"!=" {
	column+=yyleng;
	yylval.entite=yytext;
	return NOT_EG;
}


IF {
	column+=yyleng;
	yylval.entite = yytext;
	return IF;
}
ELSE {
	column+=yyleng;
	yylval.entite = yytext;
	return ELSE;
}
FOR {
	column+=yyleng;
	yylval.entite = yytext;
	return FOR;
}
IFELSE {
	column+=yyleng;
	yylval.entite = yytext;
	return IFELSE;
}
WHILE {
	column+=yyleng;
	yylval.entite = yytext;
	return WHILE;
}
IN {
	column+=yyleng;
	yylval.entite = yytext;
	return IN;
}

"[" {
	column+=yyleng;
	yylval.entite = yytext;
	return OPEN_BRACE;
}
"]" {
	column+=yyleng;
	yylval.entite = yytext;
	return CLOSE_BRACE;
}
"{" {
	column+=yyleng;
	yylval.entite = yytext;
	return OPEN_ACO;
}
"}" {
	column+=yyleng;
	yylval.entite = yytext;
	return CLOSE_ACO;
}
"(" {
	column+=yyleng;
	yylval.entite = yytext;
	return OPEN_PARENT;
}
")" {
	column+=yyleng;
	yylval.entite = yytext;
	return CLOSE_PARENT;
}
":" {
	column+=yyleng;
	yylval.entite = yytext;
	return DOUBLE_DOT;
}
"," {
	column+=yyleng;
	yylval.entite = yytext;
	return COMMA;
}

"<-" {
	column+=yyleng;
	yylval.entite = yytext;
	return AFF;
}


" "|\t {
	column+=yyleng;
}

\n {
	line++; 
	column=1;
	return ENTER;
}

"#".* {} // Ignorer les commentaires

. {
	errors++;
	printf("Erreur lexical : ligne %d colonne %d : %s\n",line,column,yytext);
	column+=yyleng;
}
%%

int yywrap(){ return 1; }