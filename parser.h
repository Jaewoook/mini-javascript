extern int column;
int yylex();
void yyerror(const char *msg);
void debug(const char *msg, char *val);

typedef enum {
    Statement, Identifier, Literal, Operator
} NODEType;

typedef struct NODE {
    NODEType type;
    char *name;
    char *val;
    struct NODE *child;
    struct NODE *next_sibling;
} node;

node *sibling_node(node *before, node *next);
node *identifier_node(char *name);
node *literal_node(char *value);
node *operator_node(char *name, node *left, node *right);
node *statement_node(char *name);
node *put_node(NODEType type, char *name, char *value, node *next_sibling, node *child);
node *create_node();
void delete_node(node *node);

node *root;