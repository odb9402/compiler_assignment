# Shell Script to compile lex & yacc analyzer and interpreter

lex odb_compiler.l
yacc -d odb_compiler.y
cc lex.yy.c y.tab.c interpreter.c
