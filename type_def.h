typedef enum { typeInt, typeFloat, typeId, typeOpr } nodeEnum;

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
	int index; //it is subscript to symbol table array. 
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

/* symbol table */
extern double sym[26];
