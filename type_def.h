#define ABSOLUTE 1
#define PLUS 2
#define MINUS 3
#define MULT 4
#define DIVIDE 5
#define END 6
#define EQ 7

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
