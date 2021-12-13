#include <stdio.h>
#include <string.h>
#if YYDEBUG == 1
#include "d-y.tab.c"
#else
#include "y.tab.c"
#endif
#include "lex.yy.c"

node *put_value(char *type, char *value) {

}

node *put_node(char *type, node *node) {

}

node *create_node() {
    node *newnode = (node *) malloc(sizeof(node));
    return newnode;
}

void delete_node(node *node) {
    if (node == NULL) return;

    if (node->child) delete_node(node->child);
    if (node->next_sibling) delete_node(node->next_sibling);
}

void debug(const char *msg, char *val) {
    printf("debug: %-30s at line %-4d value (%s)\n", msg, yylineno, val);
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
    for (int i = 0; i < 80; i++) putchar('-'); putchar('\n');
    printf("%30s %33s\n", "debug information", "value (value)");
    for (int i = 0; i < 80; i++) putchar('-'); putchar('\n');
    if (!yyparse()) {
        printf("\nParsing complete.\n");
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
