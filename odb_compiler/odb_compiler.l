 /* definitions */
digit	[0-9]
letter	[A-Za-z]

%{
	#include <stdlib.h>
	void yyerror(char *);
	#include "type_def.h"
	#include "y.tab.h"
%}
%option yylineno


%%

"int"		{ return T_INT; }
"float"		{ return T_FLOAT; }
"char"		{ return T_CHAR; }
"double"	{ return T_DOUBLE; }
"abs"		{ return RES_ABS; }

[0-9]+ 			{

		yylval.iValue = atoi(yytext);
		return INTEGER;	
}


[0-9]+"."[0-9]*     	{
		yylval.fValue = atof(yytext);
		return FLOAT;
}


[A-Za-z]([A-Za-z]|[0-9]|"_")*	{
		yylval.sValue = *yytext;
		return ID;
}

 /* operators */

[-+()=/*;{}!]	{
		return *yytext;
}

"<="		return RE;
">="		return LE;
"=="		return EQ;
"!="		return NE;
"while"		return WHILE;
"for"		return FOR;
"if"		return IF;
"else"		return ELSE;
"print"		return PRINT;

 /* white space skip */
[ \t]+		;
[ \n]		{ yylineno = yylineno + 1; }

.			yyerror("Unknown character");


%%


int yywrap(void) {
	return 1;
}

/*
void copy(char* yytext, char* str){
	str = malloc(strlen(yytext)+1);
	if ( str == NULL ) abort();
	strcpy(str,yytext);	
}


int check_table(char* token_table[], int number, char* yytext){
	int i = 0;

	for( i = 0 ; i < number ; i ++ ){
		if( strcmp(token_table[i], yytext) == 0 )
			return i;
	}

	return -1;
}*/