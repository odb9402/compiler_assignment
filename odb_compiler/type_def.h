#define ABSOLUTE 1
#define PLUS 2
#define MINUS 3
#define MULT 4
#define DIVIDE 5
#define END 6
#define EQUAL 7
#define RIGHT_GE 8
#define LEFT_GE 9
#define NOT_EQUAL 10
#define B_EQUAL 11
#define RIGHT_G 12
#define LEFT_G 13
#define NOT 14

#define WHILE_LOOP 15
#define IF_THEN_ELSE 16
#define FOR_LOOP 17
#define PRINT_OUT 18

#define TYPE_DEC 19
#define ARY_TYPE_DEC 20

#define SYM_LENGTH 256

#define TYPE_INT 1001
#define TYPE_FLOAT 1002
#define TYPE_CHAR 1003
#define TYPE_STRING 1004
#define TYPE_FUNCTION 1005

typedef enum { typeInt, typeFloat, typeId, typeOpr , typeTypedef } nodeEnum;

/* Value Identifier can have */
typedef union {
	int bValue;
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
	int sym_index;
	char* name; //symbol_table_name;
} idNodeType;

/* operations */
typedef struct {
	int oper; // operator types
	int nops; // number of operands
	struct nodeTypeTag *op[1]; // operands : pointer to operands
} oprNodeType;

typedef struct {
	int value;
} typeDefNodeType;

typedef struct nodeTypeTag{
	nodeEnum type;

	union {
		intNodeType int_const;
		floatNodeType float_const;
		idNodeType id;
		oprNodeType opr;
		typeDefNodeType type_const;
	};
} nodeType;


typedef struct sym{
	char *sym_name;		// Key of the hash table.
	int sym_type;		// Type of the symbol.
	s_value sym_val;	// Data of the hash table.
} symbol;

/* symbol table elements */
typedef struct sym_table{
	int scope_depth;
	int scope_order;
	struct sym sym_hash[SYM_LENGTH];
	struct sym_table** c_table; // child tables.
} symbol_table;

extern symbol_table sym_head;