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
    INCR = 258,
    DECR = 259,
    T_INT = 260,
    T_FLOAT = 261,
    T_CHAR = 262,
    T_STRING = 263,
    INTEGER = 264,
    FLOAT = 265,
    ID = 266,
    WHILE = 267,
    IF = 268,
    PRINT = 269,
    FOR = 270,
    RES_ABS = 271,
    IFX = 272,
    ELSE = 273,
    GE = 274,
    LE = 275,
    RE = 276,
    EQ = 277,
    NE = 278,
    UMINUS = 279,
    stmt = 280
  };
#endif
/* Tokens.  */
#define INCR 258
#define DECR 259
#define T_INT 260
#define T_FLOAT 261
#define T_CHAR 262
#define T_STRING 263
#define INTEGER 264
#define FLOAT 265
#define ID 266
#define WHILE 267
#define IF 268
#define PRINT 269
#define FOR 270
#define RES_ABS 271
#define IFX 272
#define ELSE 273
#define GE 274
#define LE 275
#define RE 276
#define EQ 277
#define NE 278
#define UMINUS 279
#define stmt 280

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

#line 114 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
