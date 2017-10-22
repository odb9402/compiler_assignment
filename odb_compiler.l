 /* definitions */
digit	[0-9]
letter	[A-Za-z]

%{
	#include <stdlib.h>
	void yyerror(char *);
	#include "type_def.h"
	#include "y.tab.h"

	int number = 0;
	int token_type[100];
	char* token[100];
	int table_num = 0;

%}
%option yylineno


%%

"abs"	{
	return RES_ABS;
}

[0-9]+ 			{

		table_num = check_table(token, number, yytext);

		if ( table_num == -1 ){
			token[number] = copy(yytext, token[number]);
			token_type[number] = INTEGER;
			//printf( "[%s]", token[number]);
			number++;
			}
		else{
			//printf("<%d::%s,%d>", table_num,token[table_num],token_type[table_num]);
			}
		yylval.iValue = atoi(yytext);
		return INTEGER;	
}


[0-9]+"."[0-9]*     	{
		table_num = check_table(token, number, yytext);

		if ( table_num == -1 ){
			token[number] = copy(yytext, token[number]);
			token_type[number] = FLOAT;
			//printf( "[%s]", token[number]);
			number++;
			}
		else{
			//printf("<%d::%s,%d>", table_num,token[table_num],token_type[table_num]);
			}
		yylval.fValue = atof(yytext);
		return FLOAT;
}


[A-Za-z]([A-Za-z]|[0-9]|"_")*	{
		table_num = check_table(token, number, yytext);

		if ( table_num == -1 ){
			token[number] = copy(yytext, token[number]);
			token_type[number] = ID;
			//printf( "[%s]", token[number]);
			number++;
			}
		else{
			//printf("<%d::%s,%d>", table_num,token[table_num],token_type[table_num]);
			}
		
		int i;
		
		//if ((i = resWord(yytext)) != 0)
		//		return (i);

		yylval.sIndex = *yytext - 'a';
		return ID;
}

 /* operators */

[-+()=/*;{}]	{
		return *yytext;
}

 /* white space skip */
[ \t\n]+	;


.			yyerror("Unknown character");


%%


int yywrap(void) {
	return 1;
}


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
}
