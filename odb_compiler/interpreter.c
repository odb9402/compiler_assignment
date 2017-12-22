#include <stdio.h>
#include "type_def.h"
#include "y.tab.h"

double ex(nodeType *p){
	double float_value;
	
	if (!p)
		return 0;

	switch(p->type){
	
	case typeInt:
		return p->int_const.value;
	
	case typeFloat:
		return p->float_const.value;

	case typeId:
		//printf("%f\n",sym[p->id.index]);
		//return sym[p->id.index];
		return 0;

	case typeOpr:
		switch(p->opr.oper){
			/* End of statement*/
			case END:{
				ex(p->opr.op[0]);
				return ex(p->opr.op[1]);
				}
		
			/* terminal */
			case EQUAL:
				sym_head.sym_hash[p->opr.op[0]->id.sym_index].sym_val = ex(p->opr.op[1]);
				return 0;
			case UMINUS:
				return -ex(p->opr.op[0]);
			case PLUS:
				return ex(p->opr.op[0]) + ex(p->opr.op[1]);
			case MINUS:
				return ex(p->opr.op[0]) - ex(p->opr.op[1]);
			case MULT:
				return ex(p->opr.op[0]) * ex(p->opr.op[1]);
			case DIVIDE:
				return ex(p->opr.op[0]) / ex(p->opr.op[1]);
			case ABSOLUTE:
				float_value = ex(p->opr.op[0]);
				if( float_value < 0 )
					return -1 * float_value;
				else
					return float_value;
			case NOT:
				return !(ex(p->opr.op[0]));
			case RIGHT_GE:
				return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
			case LEFT_GE:
				return ex(p->opr.op[0]) >= ex(p->opr.op[1]);
			case NOT_EQUAL:
				return ex(p->opr.op[0]) != ex(p->opr.op[1]);
			case B_EQUAL:
				return ex(p->opr.op[0]) == ex(p->opr.op[1]);
			case RIGHT_G:
				return ex(p->opr.op[0]) < ex(p->opr.op[1]);
			case LEFT_G:
				return ex(p->opr.op[0]) > ex(p->opr.op[1]);
			
			case IF_THEN_ELSE:
				if (ex(p->opr.op[0]))
					ex(p->opr.op[1]);
				else if (p->opr.nops > 2)
					ex(p->opr.op[2]);
				return 0;

			case WHILE_LOOP:
				while(ex(p->opr.op[0]))
					ex(p->opr.op[1]);
				return 0;

			case FOR_LOOP:
				for(ex(p->opr.op[0]) ; ex(p->opr.op[1]) ; ex(p->opr.op[2]))
					ex(p->opr.op[3]);

			case PRINT_OUT:
				//print by types.
				return 0;

		}
	}

	return 0;
}
