#include <stdio.h>
#include <string.h>

#include "type_def.h"
#include "y.tab.h"

int del = 1; // graph column distance
int eps = 3; // graph line distance

void graphInit(void);
void graphFinish();
void graphBox(char *s, int *w, int *h);
void graphDrawBox ( char *s, int c, int l);
void graphDrawArrow (int c1, int l1, int c2, int l2);

void exNode (nodeType *p, int c, int l, int *ce, int *cm);

int ex(nodeType *p){
	int rte, rtm;

	graphInit();
	exNode(p, 0, 0, &rte, &rtm);
	graphFinish();
	return 0;
}

void exNode(nodeType *p, int c, int l, int *ce, int *cm){
	int width, height;
	char *s;
	int cbar;

	int child_num;
	int child_start;
	int che, chm;
	char word[20];

	if (!p) return;

	strcpy (word, "???");
	s = word;
	switch(p->type){
		case typeInt:
			sprintf(word, "int(%d)", p->int_const.value);
			break;
		case typeFloat:
			sprintf(word, "float(%f)", p->float_const.value);
			break;
		case typeId:
			sprintf(word, "id(%c)", p->id.index + 'A');
			break;
		case typeOpr:
			switch(p->opr.oper){
				case ABSOLUTE:
					s = "ABS";
					break;
				case PLUS:
					s = "[+]";
					break;
				case MINUS:
					s = "[-]";
					break;
				case MULT:
					s = "[*]";
					break;
				case DIVIDE:
					s = "[/]";
					break;
				case END:
					s = "[;]";
					break;
				case EQ:
					s = "[=]";
					break;
			}
			break;
	}
	
	graphBox(s, &width, &height);
	cbar = c;
	*ce = c + width;
	*cm = c + width / 2;

	if ( p->type == typeInt || p->type == typeFloat || p->type == typeId ||	p->opr.nops == 0 ){
		graphDrawBox(s, cbar, l);
		return;
	}

	child_start = c;
	for ( child_num = 0; child_num < p->opr.nops; child_num++ ){
		exNode(p->opr.op[child_num], child_start, l + height + eps, &che, &chm);
		child_start = che;
	}

	if ( width < che - c ) {
		cbar += (che - c - width) / 2;
		*ce = che;
		*cm = (c+che) / 2;
	}

	graphDrawBox(s, cbar, l);

	child_start = c;
	for( child_num = 0 ;  child_num < p->opr.nops; child_num++ ){
		exNode(p->opr.op[child_num], child_start, l+height+eps, &che, &chm);
		graphDrawArrow(*cm, l+height, chm, l+height+eps-1);
		child_start = che;
	}
}

/* drawing graph */

#define lmax 200
#define cmax 200

char graph[lmax][cmax];
int graphNumber = 0;

void graphTest(int l, int c){
	int ok;
	ok = 1;

	if ( l < 0 ) ok = 0;
	if ( l >= lmax ) ok = 0;
	if ( c < 0 ) ok = 0;
	if ( c >= cmax ) ok = 0;
	if (ok) return;

	printf (" error ");
	exit(1);
}


void graphInit(void){
	int i, j;
	for(i = 0 ; i < lmax; i++){
		for(j = 0; j < cmax; j++){
			graph[i][j] = ' ';
		}
	}
}


void graphFinish(){
	int i, j;
	for(i = 0; i < lmax; i++){
		for (j = cmax -1 ; j > 0 && graph[i][j] == ' '; j--);
		graph[i][cmax-1] = 0;
		if ( j < cmax-1)
			graph[i][j+1] = 0;
		if ( graph[i][j] == ' ' )
			graph[i][j] = 0;
	}
	for ( i = lmax - 1; i > 0 && graph[i][0] == 0; i--);
	printf ("\n\nGraph %d:\n", graphNumber++);
	for ( j = 0; j <= i ; j++)
		printf("\n%s", graph[j]);
	printf("\n");
}


void graphBox(char *s, int *w, int *h){
	*w = strlen(s) + del;
	*h = 1;
}


void graphDrawBox(char *s, int c, int l){
	int i;
	graphTest(l, c+strlen(s)-1+del);
	for(i = 0; i < strlen(s); i++)
		graph[l][c+i+del] = s[i];
}


void graphDrawArrow(int c1, int l1, int c2, int l2){
	int m;
	graphTest(l1,c1);
	graphTest(l2,c2);
	m = ( l1 + l2 ) / 2;

	while(l1 != m){
		graph[l1][c1] = '|';
		if (l1 < l2 )
			l1++;
		else
			l1--;
	}
	while(c1 != c2){
		graph[l1][c1] = '-';
		if (c1 < c2)
			c1++;
		else
			c1--;
	}
	while(l1 != l2){
		graph[l1][c1] = '|';
		if (l1 < l2)
			l1++;
		else
			l1--;
	}
	graph[l1][c1] = '|';
}
