#include <stdio.h>
#include "type_def.h"
#include "y.tab.h"

double ex(nodeType *p){
	if (!p)
		return 0;

	switch(p->type){
	
	case typeInt:
		return p->int_const.value;
	
	case typeFloat:
		return p->float_const.value;

	case typeId:
		printf("%f\n",sym[p->id.index]);
		return sym[p->id.index];

	case typeOpr:
		switch(p->opr.oper){
		
		/* End of */
		case ';':{
			ex(p->opr.op[0]);
			return ex(p->opr.op[1]);
			}
	
		/* terminal */
		case '=':
			return sym[p->opr.op[0]->id.index] = ex(p->opr.op[1]);

		case UMINUS:
			return -ex(p->opr.op[0]);

		case '+':
			return ex(p->opr.op[0]) + ex(p->opr.op[1]);
		
		case '-':
			return ex(p->opr.op[0]) - ex(p->opr.op[1]);

		case '*':
			return ex(p->opr.op[0]) * ex(p->opr.op[1]);

		case '/':
			return ex(p->opr.op[0]) / ex(p->opr.op[1]);
		
		}
	}

	return 0;
}
