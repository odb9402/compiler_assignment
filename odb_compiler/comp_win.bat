flex odb_compiler.l
bison -dy odb_compiler.y
gcc lex.yy.c y.tab.c interpreter.c
