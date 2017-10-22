yacc -d odb_compiler.y
lex odb_compiler.l
cc lex.yy.c y.tab.c interpreter.c
