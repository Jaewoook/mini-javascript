extern int column;
int yylex();
void yyerror(const char *msg);
void debug(const char *msg, char *val);

typedef enum {
    Program, Expression, Statement, Identifier, Literal, Operator, Parameter, Function, Scope, AsyncScope,
    Jump, Call
} NODEType;

typedef struct NODE {
    NODEType type;
    char *name;
    char *val;
    struct NODE *child;
    struct NODE *next_sibling;
} node;

node *sibling_node(node *before, node *next);
node *identifier_node(char *name, int mutable);
node *literal_node(char *value);
node *operator_node(char *name, node *left, node *right);
node *statement_node(char *name);
node *function_node(char *name, int async, node *parameters, node *scope);
node *jump_node(char *name, node *child);
node *call_node(node *expression, node *arguments);
node *put_node(NODEType type, char *name, char *value, node *next_sibling, node *child);
node *create_node();
void delete_node(node *node);

node *root;
int strict_mode = 0;
