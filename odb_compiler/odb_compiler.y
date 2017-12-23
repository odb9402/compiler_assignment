%{
	#include <stdlib.h>
	#include <stdarg.h>
	#include <stdio.h>
	#include "type_def.h"

	void yyerror(char *);
	int yylex(void);
	int yylineno;
	extern FILE *yyin;
	extern FILE *fopen(const char *filename, const char *mode);

	nodeType *opr(int oper, int nops, ...);
	nodeType *id(char* id_string);
	nodeType *int_con(int value);
	nodeType *float_con(double value);
	nodeType *type_con(int value);
	nodeType *array(char* id_string, unsigned int index);
	void freeNode(nodeType *p);
	double ex(nodeType *p);
	symbol_table init_table();
	void assign(char* id_string, int type);
	int get_type(nodeType* type_node);
	unsigned int calc_hash_index(symbol_table table, char* name);
	void look_up_sym();
	symbol_table sym_head;
%}

%union {
	/* Definition of YYSTYPE, it is type of yylval.*/

	int iValue;		// int value
	int addrValue;
	double fValue;	// float value
	char* sValue;
	nodeType *nPtr;	// node pointer
};

%token INCR DECR
%token T_INT T_FLOAT T_CHAR T_STRING
%token <iValue> INTEGER
%token <fValue> FLOAT
%token <sValue> ID
%token WHILE IF PRINT
%token RES_ABS
%nonassoc IFX
%nonassoc ELSE

%right '='
%left GE LE RE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> statement expr statement_list function_call array_usage Type declaration


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
		';'										{ printf("justnull "); $$ = opr(END, 2, NULL, NULL); }
	| function_call								{ $$ = $1; }
	| declaration								{ $$ = $1; }
	| expr ';'									{ $$ = $1; }
	| PRINT expr ';'							{ $$ = opr(PRINT_OUT, 1, $2);}
	| WHILE '(' expr ')' statement 				{ printf("while "); $$ = opr(WHILE_LOOP, 2, $3, $5);}
	| IF '(' expr ')' statement	%prec IFX		{ printf("if "); $$ = opr(IF_THEN_ELSE, 2, $3, $5);}
	| IF '(' expr ')' statement ELSE statement	{ $$ = opr(IF_THEN_ELSE, 3, $3, $5, $7);}
	| ID '=' expr ';'							{ $$ = opr(EQUAL, 2, id($1), $3);}
	| '{' statement_list '}'					{ $$ = $2; }
	;

statement_list:
	statement 									{ $$ = $1; }
	| statement_list statement					{ printf("end "); $$ = opr(END, 2, $1, $2); }
	;

// Grammars for declarations.
declaration:
	Type ID ';'									{ assign($2, get_type($1)); $$ = id($2); }
	| Type ID '=' expr ';'						{ assign($2, get_type($1)); $$ = opr(EQUAL, 2, id($2), $4); }
	| Type array_usage ';'						{  }
	| Type array_usage '=' expr	';'				{  }
	;

// Grammars for expression. It will return some values such as float, int
// and r-value of identifiers.
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

function_call:
	ID'('')'									{}
	| ID'('expr')'								{}
	;

array_usage:
	ID'['INTEGER']'								{ $$ = array($1,$3); }
	;

Type: T_INT										{ $$ = type_con(TYPE_INT); }
	| T_FLOAT									{ $$ = type_con(TYPE_FLOAT); }
	| T_CHAR									{ $$ = type_con(TYPE_CHAR); }
	| T_STRING									{ $$ = type_con(TYPE_STRING); }
	;
%%

#define SIZEOF_NODETYPE ((char*) &p->int_const - (char*)p)


int get_type(nodeType* type_node){
	return type_node->type_const.value;
}


nodeType *type_con(int value){
	nodeType *p;

	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory : int constant");

	p->type = typeTypedef;
	p->type_const.value = value;
	
	return p;
}


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
	int table_index = 0;

	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory : identifier");

	table_index = calc_hash_index(sym_head, id_string);

	if(sym_head.sym_hash[table_index].sym_name != NULL){}
		// Search symbol tables by a hash table.
	else{
		yyerror("Identifier was not assigned.");			// If there is no symbol in the table, error.
	}
	p->type = typeId;
	p->id.name = id_string;
	p->id.sym_index = table_index;

	return p;
}


nodeType *array(char* id_string, unsigned int index){
	nodeType *p;
	int table_index = 0;
	s_value value;
}


void assign(char* id_string, int type){
	int table_index = 0;

	table_index = calc_hash_index(sym_head, id_string);
	
	if(sym_head.sym_hash[table_index].sym_name != NULL){
		yyerror("Identifier was already assigned.");
	}
	else{
		sym_head.sym_hash[table_index].sym_name = strdup(id_string);
		sym_head.sym_hash[table_index].sym_type = type;
	}
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


unsigned int calc_hash_index(symbol_table table, char* name){
    unsigned int hash_index = 5381;
	int trav_count = 0;

	if(strlen(name) == 1)		// If some identifiers are just having one char,
		return name[0];			// a hash value is an ASKII code of the char. 

	while(*(name++)){
		hash_index = ((hash_index << 5) + hash_index) + (*name);
	}
    hash_index = ( hash_index % SYM_LENGTH );

    if (table.sym_hash[hash_index].sym_name == NULL ||
			!strcmp(table.sym_hash[hash_index].sym_name, name)){
        return hash_index;
    }
    else{
        while(table.sym_hash[hash_index].sym_name == NULL ||
				!strcmp(table.sym_hash[hash_index].sym_name, name)){
            hash_index++;
            trav_count++;
			if(hash_index == SYM_LENGTH)
                hash_index = 0;
			if(trav_count == SYM_LENGTH)
				yyerror("The maximum number of identifiers is 256. :: The hash table is full");
		}
		return hash_index;
    }
}


void look_up_sym(){

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


int main(int argc, char *argv[]) {
	
	if(argc == 2){
		yyin = fopen(argv[1], "r");
		if(!yyparse())
			printf("parsing complete");
		else
			printf("parsing failed");
		fclose(yyin);
	}
	else
		yyparse();
	return 0;
}


void yyerror(char *s) {
	printf("%d : %s  \n", yylineno, s);
	exit(0);
}
