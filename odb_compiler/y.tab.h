/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_INT = 258,
    T_FLOAT = 259,
    T_CHAR = 260,
    T_STRING = 261,
    INTEGER = 262,
    FLOAT = 263,
    ID = 264,
    WHILE = 265,
    IF = 266,
    PRINT = 267,
    FOR = 268,
    RES_ABS = 269,
    IFX = 270,
    ELSE = 271,
    GE = 272,
    LE = 273,
    RE = 274,
    EQ = 275,
    NE = 276,
    UMINUS = 277
  };
#endif
/* Tokens.  */
#define T_INT 258
#define T_FLOAT 259
#define T_CHAR 260
#define T_STRING 261
#define INTEGER 262
#define FLOAT 263
#define ID 264
#define WHILE 265
#define IF 266
#define PRINT 267
#define FOR 268
#define RES_ABS 269
#define IFX 270
#define ELSE 271
#define GE 272
#define LE 273
#define RE 274
#define EQ 275
#define NE 276
#define UMINUS 277

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 29 "odb_compiler.y" /* yacc.c:1909  */

	/* Definition of YYSTYPE, it is type of yylval.*/

	int iValue;		// int value
	int addrValue;
	double fValue;	// float value
	char* sValue;
	nodeType *nPtr;	// node pointer

#line 108 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
