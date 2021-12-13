#include <stdio.h>
#include <string.h>
#if YYDEBUG == 1
#include "d-y.tab.c"
#else
#include "y.tab.c"
#endif
#include "lex.yy.c"

int number_of_node = 0;

const char *get_node_type_str(NODEType type) {
    switch (type) {
        case Statement: return "statement";
        case Identifier: return "identifier";
        case Literal: return "literal";
        case Operator: return "Operator";
        default: return "Error";
    }
}

void print_node(node *node, int depth) {
    if (node == NULL) return;
    for (int i = 0; i < depth * 10; i++) putchar(' ');
    printf("%-10s '%s' (%s)\n", get_node_type_str(node->type), node->name, node->val);

    if (node->child != NULL) {
        print_node(node->child, depth + 1);
    }
    if (node->next_sibling != NULL) {
        print_node(node->next_sibling, depth);
    }
}

node *identifier_node(char *name) {
    return put_node(Identifier, name, NULL, NULL, NULL);
}

node *literal_node(char *value) {
    return put_node(Literal, NULL, value, NULL, NULL);
}

node *statement_node(char *name) {
    return put_node(Statement, name, NULL, NULL, NULL);
}

node *operator_node(char *name, node *left, node *right) {
    return put_node(Operator, name, NULL, left, right);
}

node *put_node(NODEType type, char *name, char *value, node *next_sibling, node *child) {
    node *node = create_node();
    node->type = type;
    node->name = strdup(name != NULL ? name : "");
    node->val = strdup(value != NULL ? value : "");
    node->next_sibling = next_sibling;
    node->child = child;

    return node;
}

node *create_node() {
    node *newnode = (node *) malloc(sizeof(node));
    if (newnode == NULL) {
        yyerror("Error: out of memory");
    }
    number_of_node++;
    return newnode;
}

void delete_node(node *node) {
    if (node == NULL) return;

    if (node->child) delete_node(node->child);
    if (node->next_sibling) delete_node(node->next_sibling);

    free(node);
    number_of_node--;
}

node *sibling_node(node *before, node *next) {
    node *ret = before;

    while (before->next_sibling != NULL) {
        before = before->next_sibling;
    }
    before->next_sibling = next;
    return ret;
}

void debug(const char *msg, char *val) {
    printf("debug: %-35s at line %-4d value (%s)\n", msg, yylineno, val);
}

char *file_path;

int main(int argc, char *argv[]) {
    #if YYDEBUG == 1
    yydebug = 1;
    #endif

    int ret = 0;
    if (argc != 2) {
        fprintf(stderr, "Error: input file not provided\nUsage: ./javascript [FILE]\n");
        return 1;
    }
    file_path = argv[1];
    yyin = fopen(file_path, "r");
    if (yyin == NULL) {
        fprintf(stderr, "Error: file not available.\n");
        return 1;
    }

    /* print table header */
    for (int i = 0; i < 80; i++) putchar('-'); putchar('\n');
    printf("%30s %38s\n", "debug information", "value (value)");
    for (int i = 0; i < 80; i++) putchar('-'); putchar('\n');

    if (!yyparse()) {
        printf("\nParsing complete.\n");
        printf("Number of nodes: %d\n", number_of_node);
        print_node(root, 0);
    } else {
        printf("\nParsing failed.\n");
        ret = 1;
    }
    fclose(yyin);
    return ret;
}

void yyerror(const char *msg) {
    fflush(stdout);
    fprintf(stderr, "%s:%d:%d: %s\n\t%s\n\n", file_path, yylineno, (int) (column - yyleng), msg, yytext);
}