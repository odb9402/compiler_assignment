 /* definitions */
digit	[0-9]
letter	[A-Za-z]
%{
	#include <stdlib.h>
	#include <string.h>
%}
%option yylineno
%%

[0-9]+ 			{
		printf( " Integer : %s(%d)" , yytext, atoi(yytext));
		}

[0-9]+"."[0-9]*     	{
                printf( "A float: %s (%g)"  , yytext, atof( yytext ) );
                }

[A-Za-z]([A-Za-z]|[0-9]|"_")*	{
		printf( " Identifier: %s" , yytext);
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
}
