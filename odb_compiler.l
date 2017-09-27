 /* definitions */
digit	[0-9]
letter	[A-Za-z]
%{
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
%}
%option yylineno
%%
(letter)({letter}|{digit}|_)*		{ strcpy(yylval.id, yytext); printf("identifier found %s", yytext);}
(digit)+						{ yylval.intval = atoi(yytext); printf("int numeric found %d",yytext);}
(digit)+"."(digit)+				{ yylval.floatval = atoi(yytext); printf("float numeric found %f",yytext);}
%%

int yywrap(void){
	return 1;
}


int main(void)
{
	yylex();
	return 0;
}
