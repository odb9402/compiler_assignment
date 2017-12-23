 /* definitions */
digit	[0-9]
letter	[A-Za-z]

%{
	#include <stdlib.h>
	void yyerror(char *);
	void copy(char* yytext, char* str);
	#include "type_def.h"
	#include "y.tab.h"
%}
%option yylineno


%%

 /*Reserve words : { Types, Control statements }*/
"int"		return T_INT;
"float"		return T_FLOAT;
"char"		return T_CHAR;
"string"	return T_STRING;
"abs"		return RES_ABS;

while		return WHILE;
for			return FOR;
if			return IF;
else		return ELSE;
print		return PRINT;

"++"		return INCR;
"--"		return DECR;

[0-9]+ 			{
		yylval.iValue = atoi(yytext);
		return INTEGER;	
}


[0-9]+"."[0-9]*     	{
		yylval.fValue = atof(yytext);
		return FLOAT;
}


[A-Za-z]([A-Za-z]|[0-9]|"_")*	{
		yylval.sValue = strdup(yytext);		// deep copy for passing token of an identifer.
		return ID;
}

 /* operators */


[-()<>=+/*{}!.]	{
		return *yytext;
}

";"			return *yytext;
"<="		return RE;
">="		return LE;
"=="		return EQ;
"!="		return NE;

 /* white space skip */
[ \t]+		;
[ \n]		{ yylineno = yylineno + 1; }

.			yyerror("Unknown character");


%%

int yywrap(void) {
	return 1;
}
