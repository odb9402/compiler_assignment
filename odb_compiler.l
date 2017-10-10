 /* definitions */
digit	[0-9]
letter	[A-Za-z]
%{
	#include <stdlib.h>
	#include <string.h>
	enum {
		ID = 0,
		INTEGER = 1,
		FLOAT = 2
	};

	int number = 0;
	int token_type[100];
	char* token[100];
	int table_num = 0;

%}
%option yylineno

%%

[0-9]+ 			{

		table_num = check_table(token, number, yytext);

		if ( table_num == -1 ){
			token[number] = copy(yytext, token[number]);
			token_type[number] = INTEGER;
			printf( "[%s]", token[number]);
			number++;
			}
		else{
			printf("<%d::%s,%d>", table_num,token[table_num],token_type[table_num]);
			}		
		}

[0-9]+"."[0-9]*     	{
		table_num = check_table(token, number, yytext);

		if ( table_num == -1 ){
			token[number] = copy(yytext, token[number]);
			token_type[number] = FLOAT;
			printf( "[%s]", token[number]);
			number++;
			}
		else{
			printf("<%d::%s,%d>", table_num,token[table_num],token_type[table_num]);
			}
                }

[A-Za-z]([A-Za-z]|[0-9]|"_")*	{
		table_num = check_table(token, number, yytext);

		if ( table_num == -1 ){
			token[number] = copy(yytext, token[number]);
			token_type[number] = ID;
			printf( "[%s]", token[number]);
			number++;
			}
		else{
			printf("<%d::%s,%d>", table_num,token[table_num],token_type[table_num]);
			}
		}

%%

main(argc, argv)
int argc;
char **argv;
{	
	++argv, -argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r");
	else
		yyin = stdin;
	yylex();


	printf("\n\nSYMBOL TABLE :: \n");
	int i = 0;
	for ( i = 0 ; i < number ; i ++ ){
		printf("<%d::%s,%d>\n", i,token[i],token_type[i]);
	}
}


void copy(char* yytext, char* str){
	str = malloc(strlen(yytext)+1);
	if ( str == NULL ) abort();
	strcpy(str,yytext);	
}


int check_table(char* token_table[], int number, char* yytext){
	int i = 0;

	for( i = 0 ; i < number ; i ++ ){
		if( strcmp(token_table[i],yytext) == 0 )
			return i;
	}

	return -1;
}
