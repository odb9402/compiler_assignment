#define ABSOLUTE 1
#define PLUS 2
#define MINUS 3
#define MULT 4
#define DIVIDE 5
#define END 6
#define EQ 7

typedef enum { typeInt, typeFloat, typeId, typeOpr } nodeEnum;

/* Value Identifier can have */
typedef union {

	int iValue;
	int addrValue;
	double fValue;
	char* sValue;
	char cValue;

} s_value; 

/* integer constant type */
typedef struct {
	int value;
} intNodeType;

/* float constant type */
typedef struct {
	double value;
} floatNodeType;

/* indentifiers */
typedef struct {
	char* name; //symbol_table_name;
} idNodeType;

/* operations */
typedef struct {
	int oper; // operator types
	int nops; // number of operands
	struct nodeTypeTag *op[1]; // operands : pointer to operands
} oprNodeType;

typedef struct nodeTypeTag{
	nodeEnum type;

	union {
		intNodeType int_const;
		floatNodeType float_const;
		idNodeType id;
		oprNodeType opr;
	};
} nodeType;

/* symbol table elements */
typedef struct sym_table{
	int scope_depth;
	int scope_order;

	struct symbol{
		int length;
		char *sym_name;
		s_value sym_val;
		symbol* next_sym;
	}sym;

	sym_table** c_table; // child tables.
}

/* symbol table */
extern double sym[26];
