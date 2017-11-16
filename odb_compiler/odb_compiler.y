%{
	#include <stdlib.h>
	#include <stdarg.h>
	#include <stdio.h>
	#include "type_def.h"
	
	nodeType *opr(int oper, int nops, ...);
	nodeType *id(int i);
	nodeType *int_con(int value);
	nodeType *float_con(double value);
	void freeNode(nodeType *p);
	int ex(nodeType *p);
	int yylex(void);

	void yyerror(char *);
	double sym[26]; // Symbol Table.
	nodeSymbol sym_head; //symbol_table head.
	sym_head = init_table();
%}

%union {
	/* Definition of YYSTYPE, it is type of yylval.*/

	int iValue;		// int value
	double fValue;	// float value
	char* sIndex;	// symbol table index
	nodeType *nPtr;	// node pointer
};

%token <iValue> INTEGER
%token <fValue> FLOAT
%token <sIndex> ID
%token WHILE IF PRINT
%token RES_ABS
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
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
		';'						{ $$ = opr(END, 2, NULL, NULL); }
	| expr ';'					{ $$ = $1; }
	| ID '=' expr ';'			{ $$ = opr(EQ, 2, id($1), $3); }
	| '{' statement_list '}'	{ $$ = $2; }
	;

statement_list:
	statement 					{ $$ = $1; }
	| statement_list statement	{ $$ = opr(END, 2, $1, $2); }
	;

expr:
	FLOAT					{ $$ = float_con($1);}
	| INTEGER				{ $$ = int_con($1); }
	| ID					{ $$ = id($1); }
	| '-' expr %prec UMINUS { $$ = opr(UMINUS , 1, $2); }
	| expr '+' expr			{ $$ = opr(PLUS, 2, $1, $3); }
	| expr '-' expr			{ $$ = opr(MINUS, 2, $1, $3); }
	| expr '*' expr			{ $$ = opr(MULT, 2, $1, $3); }
	| expr '/' expr			{ $$ = opr(DIVIDE, 2, $1, $3); }
	| RES_ABS expr 			{ $$ = opr(ABSOLUTE, 1, $2); }
	| '(' expr ')'			{ $$ = $2;}
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


nodeType *id(int i){
	nodeType *p;

	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory : identifier");

	p->type = typeId;
	p->id.index = i;

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


sym_table init_table(){
	sym_table head;
	
	head.scope_depth = 0;
	head.scope_order = 0;
	head.sym.length = 0;

	return head;
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


