extern int column;
int yylex();
void yyerror(const char *msg);
void debug(const char *msg, char *val);

typedef struct NODE {
    char *name;
    char *type;
    int num_of_child;
    char *val;
    struct NODE *child;
    struct NODE *next_sibling;
} node;

node *put_value(char *type, char *value);
node *put_node(char *type, node *node);
node *create_node();
void delete_node(node *node);
