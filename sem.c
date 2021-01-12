#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
#include "sem.h"

#include <malloc.h>
#include <string.h>

extern unsigned short errors;
extern unsigned short line;
extern unsigned short column;


void declaration_variable(const char * entite, const char type, const char nature, const short taille){
	if(rechercher(entite)){ // Variable déclarée précédemment.
		errors++;
		printf("Erreur semantique : ligne %u colonne %u : %s a ete deja declaree !\n", line, column, entite);
	}
	else{
		if(nature=='T' && taille<1){ // Vecteur avec une taille nulle ou négative.
			errors++;
			printf("Erreur semantique : ligne %u colonne %u : %s vecteur de taille inferieur à 1 !\n", line, column, entite);
		}
		else inserer(entite, type, nature, taille);
	}
}
int verifierDeclaration(const char * variable){
	if(!rechercher(variable)){ // Variable non déclarée.
		errors++;
		printf("Erreur semantique : ligne %u colonne %u : %s non déclarée !\n", line, column, variable);
		return 0;
	}
	return 1;
}
char verifierCompatibiliteArithmetique(char type1, char type2){
	if(type1==type2) return type1; // Les types identiques sont compatibles.
	else{
		errors++;
		printf("Erreur sémantique : ligne %u colonne %u : Les types %s et %s sont incompatibles pour une opération arithméthique !\n", line, column, type_str(type1), type_str(type2));
		return '\0';
	}
}
int verifierCompatibiliteAffectation(char type1, char type2){
	if(type1==type2) return 1;
	else {
		errors++;
		printf("Erreur sémantique : ligne %u colonne %u : Impossible d'affecter un opérand %s à un opérand %s !\n", line, column, type_str(type2), type_str(type1));
		return 0;
	}
}
int verifierIndiceVecteur(char type){
	if(type != 'I'){
		errors++;
		printf("Erreur sémantique : ligne %u colonne %u : l'indice d'un élément de vecteur doit être un entier !\n", line, column);
		return 0;
	}
	else return 1;
}


int verifierCompatibiliteComparaison(char type1, char type2){
	if(type1==type2) return 1;
	else{
		errors++;
		printf("Erreur sémantique : ligne %u colonne %u : Les types %s et %s sont incompatibles pour la comparaison !\n", line, column, type_str(type1), type_str(type2));
		return 0;
	}
}
//la fonction pour l'ajout  les quadruplets
/* --------------------------- structure de la liste des quadruplets ---------------------------------------*/

typedef struct quadr{
    char oper[100]; // pour le stockage des differents operateurs telsque  Br , *,/,+,- ....etc 
    char op1[100];   
    char op2[100];  
    char res[100];  // resultat
    struct quadr *svt;
  }quadr;
 quadr*teteQ=NULL, * queue=NULL;


 void Quad(char *oper,char *op1,char *op2,char *res)
 {
 quadr* tempo;
 tempo=(quadr*)malloc( sizeof(quadr) );
 strcpy(tempo->oper, oper );
 strcpy(tempo->op1, op1 );
 strcpy(tempo->op2, op2 );
 strcpy(tempo->res, res);
 tempo->svt=NULL;
 if(teteQ==NULL){ teteQ=queue=tempo;} else{queue->svt=tempo;queue=tempo;}
 }
//affichage des QUADRUPLETS
void afficher_quadr()
{

int nbr_quad=1;//0    /* la numerotation des quadruplets commence a partir du numero 1 */ 
quadr *k;

printf("\n ******* LES QUADs : *******\n");
for(k=teteQ;k!=NULL;k=k->svt)
{ 
printf(" %d - ( %s  ,  %s  ,  %s  ,  %s ) \n",nbr_quad,k->oper,k->op1,k->op2,k->res); 
nbr_quad++;
}
 

}