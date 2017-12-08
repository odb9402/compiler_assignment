%{
	#include <stdlib.h>
	#include <stdarg.h>
	#include <stdio.h>
	#include "type_def.h"
	
	nodeType *opr(int oper, int nops, ...);
	nodeType *id(char* id_string);
	nodeType *int_con(int value);
	nodeType *float_con(double value);
	void freeNode(nodeType *p);
	int ex(nodeType *p);
	int yylex(void);
	symbol_table init_table();
	unsigned int calc_hash_index(symbol_table table, char* name);

	void yyerror(char *);
	double sym[26]; // Symbol Table.
	symbol_table sym_head = { .scope_depth = 0, .scope_order = 0};
%}

%union {
	/* Definition of YYSTYPE, it is type of yylval.*/

	int iValue;		// int value
	int addrValue;
	double fValue;	// float value
	char* sValue;
	char cValue;	// symbol table index
	nodeType *nPtr;	// node pointer
};

%token <iValue> INTEGER
%token <fValue> FLOAT
%token <sValue> ID
%token WHILE IF PRINT
%token RES_ABS
%nonassoc IFX
%nonassoc ELSE

%left GE LE RE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> statement expr statement_list


%%

program:
	function					{ exit(0); }
	;

 /*In function which mean the sentence before the ';',
  start to depth-first execution about parse-tree.*/

function:
	function statement			{ ex($2); freeNode($2); }
	| /*NULL*/
	;

statement:
		';'										{ $$ = opr(END, 2, NULL, NULL); }
	| expr ';'									{ $$ = $1; }
	| PRINT expr ';'							{ $$ = opr(PRINT, 1, $2);}
	| WHILE '(' expr ')' statement 				{ $$ = opr(WHILE, 2, $3, $5);}
	| IF '(' expr ')' statement					{ $$ = opr(IF, 2, $3, $5);}
	| IF '(' expr ')' statement ELSE statement	{ $$ = opr(IF, 3, $3, $5, $7);}
	| ID '=' expr ';'							{ $$ = opr(EQUAL, 2, id($1), $3);}
	| '{' statement_list '}'					{ $$ = $2; }
	;

statement_list:
	statement 									{ $$ = $1; }
	| statement_list statement					{ $$ = opr(END, 2, $1, $2); }
	;

expr:
	FLOAT										{ $$ = float_con($1);}
	| INTEGER									{ $$ = int_con($1); }
	| ID										{ $$ = id($1); }
	| '-' expr %prec UMINUS 					{ $$ = opr(UMINUS , 1, $2); }
	| expr '+' expr								{ $$ = opr(PLUS, 2, $1, $3); }
	| expr '-' expr								{ $$ = opr(MINUS, 2, $1, $3); }
	| expr '*' expr								{ $$ = opr(MULT, 2, $1, $3); }
	| expr '/' expr								{ $$ = opr(DIVIDE, 2, $1, $3); }
	| RES_ABS expr 								{ $$ = opr(ABSOLUTE, 1, $2); }
	| '!' expr									{ $$ = opr(NOT, 1, $2);}
	| expr RE expr								{ $$ = opr(RIGHT_GE, 2, $1, $3); }
	| expr LE expr								{ $$ = opr(LEFT_GE, 2, $1, $3); }
	| expr NE expr								{ $$ = opr(NOT_EQUAL, 2, $1, $3); }
	| expr EQ expr								{ $$ = opr(B_EQUAL, 2, $1, $3); }
	| expr '>' expr								{ $$ = opr(LEFT_G, 2, $1, $3); }
	| expr '<' expr								{ $$ = opr(RIGHT_G, 2, $1, $3); }
	| '(' expr ')'								{ $$ = $2;}
	;

%%

#define SIZEOF_NODETYPE ((char*) &p->int_const - (char*)p)


nodeType *int_con(int value){
	nodeType *p;

	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory : int constant");

	p->type = typeInt;
	p->int_const.value = value;
	
	return p;
}


nodeType *float_con(double value){
	nodeType *p;

	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory : float constant");

	p->type = typeFloat;
	p->float_const.value = value;
	
	return p;
}


nodeType *id(char* id_string){
	nodeType *p;

	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory : identifier");

	p->type = typeId;
	p->id.name = id_string;

	// Search symbol tables by a hash table.


	// If there is no symbol in the table, create new Id.

	return p;
}


nodeType *opr(int oper, int nops, ...){
	va_list ap;
	nodeType *p;
	int i;
	int allocSize;
	allocSize = malloc(sizeof(nodeType)+ (nops-1) * sizeof(nodeType*)); 

	if ((p = malloc(allocSize)) == NULL )
		yyerror("out of memory : operator");

	p->type = typeOpr;
	p->opr.oper = oper;
	p->opr.nops = nops;
	va_start(ap, nops);

	for ( i = 0; i < nops; i++ )
		p->opr.op[i] = va_arg(ap, nodeType*);
	
	va_end(ap);
	return p;
}

/* 	Internal funcion to calculate hash for keys.
	It's based on the DJB algorithm from Daniel J. Bernstein.
	The key must be ended by '\0' character.*/
unsigned int calc_hash_index(symbol_table table, char* name){
    unsigned int hash_index = 5381;
	int trav_count = 0;

	while(*(name++)){
		hash_index = ((hash_index << 5) + hash_index) + (*name);
        printf("%d\n",hash_index);
	}
    hash_index %= SYM_LENGTH;

    if (table.sym_hash[hash_index].sym_name == NULL){
        return hash_index;
    }
    else{
        while(table.sym_hash[hash_index].sym_name == NULL){
            hash_index++;
            trav_count++;
			if(hash_index == SYM_LENGTH)
                hash_index = 0;
			if(trav_count == SYM_LENGTH)
				exit("The maximum number of identifiers is 256. :: The hash table is full");
		}
		return hash_index;
    }
}


void freeNode(nodeType *p){
	int i;

	if(!p) return;
	if(p->type == typeOpr){
		for ( i = 0; i < p->opr.nops; i++)
			freeNode(p->opr.op[i]);
	}
	free(p);
}


void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
	return 0;
}


int main(void) {
	yyparse();
	return 0;
}
