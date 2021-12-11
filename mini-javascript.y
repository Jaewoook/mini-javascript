%{
#include <stdio.h>

extern int column;
int yylex();
void yyerror(const char *msg);
%}


%token TOKEN_EOF
%token VAR
%token LET
%token CONST
%token FUNCTION
%token ARROW_FUNCTION
%token SEMICOLON
%token COLON
%token IDENTIFIER
%token FOR
%token WHILE
%token IF
%token ELSE
%token RETURN
%token SWITCH
%token CASE
%token BREAK
%token CONTINUE
%token NEW
%token DELETE
%token INSTANCEOF
%token IN
%token OF
%token THIS
%token ASYNC
%token AWAIT
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET
%token LITERAL_TRUE
%token LITERAL_FALSE
%token LITERAL_NAN
%token LITERAL_NULL
%token LITERAL_UNDEFINED
%token DQUOTE
%token SQUOTE
%token TQUOTE
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token EQ
%token NOT_EQ
%token NOT
%token DOT
%token AND
%token OR
%token COMMA
%token MODULO
%token TERNARY
%token INCREASE
%token DECREASE
%token ADD_ASSIGN
%token SUBTRACT_ASSIGN
%token MULTIPLY_ASSIGN
%token DIVIDE_ASSIGN
%token MODULO_ASSIGN
%token LT
%token GT
%token LTE
%token GTE
%token NUMBER
%token STRING

%union {
    char *string_val;
    char *num_val;
}

%error-verbose

%%

start
    : statement
    | start statement
    ;

primary_expression
    : IDENTIFIER
    | NUMBER
    | STRING
    | LPAREN expression RPAREN
    | assignment_expression
    ;

postfix_expression
    : primary_expression
    | postfix_expression LPAREN RPAREN
    | postfix_expression LPAREN arguments RPAREN
    | postfix_expression DOT postfix_expression
    | postfix_expression INCREASE
    | postfix_expression DECREASE
    | postfix_expression LBRACKET expression RPAREN
    | postfix_expression 
    ;

expression
    : assignment_expression
    | expression ',' assignment_expression
    ;

unary_expression
    : postfix_expression
    | unary_operator multiplicative_expression
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression { puts("expression"); }
    ;

conditional_expression
    : expression
    | expression TERNARY assignment_expression COLON conditional_expression
    ;

multiplicative_expression
    : unary_expression
    | multiplicative_expression MULTIPLY unary_expression
    | multiplicative_expression DIVIDE unary_expression
    | multiplicative_expression MODULO unary_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    ;

relational_expression
    : additive_expression
    | relational_expression GT additive_expression
    | relational_expression GTE additive_expression
    | relational_expression LT additive_expression
    | relational_expression LTE additive_expression
    ;

equality_expression
    : equality_expression EQ relational_expression
    | equality_expression NOT_EQ relational_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR logical_and_expression
    ;

logical_and_expression
    : logical_and_expression AND logical_or_expression
    ;

statement
    : expression_statement { puts("stastement") }
    | for_statement
    | while_statement
    | if_statement
    | declaration
    ;

expression_statement
    : SEMICOLON
    | expression
    | expression SEMICOLON
    ;

if_statement
    : IF LPAREN RPAREN scope ELSE scope
    | IF LPAREN RPAREN scope
    ;

for_statement
    : FOR LPAREN declaration expression expression RPAREN scope { puts("for statement"); }
    | FOR LPAREN 
    ;

while_statement
    : WHILE LPAREN expression RPAREN scope { puts("while statement") }
    ;

scope
    : LBRACE statement RBRACE { puts("scope"); }
    ;

declaration
    : variable_declaration { puts("variable declaration") }
    | function_declaration { puts("function declaration") }
    ;

function_declaration
    : FUNCTION IDENTIFIER LPAREN RPAREN scope
    | LPAREN RPAREN ARROW_FUNCTION scope
    ;

variable_declaration
    : type_specifier IDENTIFIER
    | type_specifier IDENTIFIER SEMICOLON
    | type_specifier IDENTIFIER EQ primary_expression
    | type_specifier IDENTIFIER EQ primary_expression SEMICOLON
    ;

type_specifier
    : VAR
    | LET
    | CONST
    ;

unary_operator
    : NOT
    | PLUS
    | MINUS
    ;

assignment_operator
    : EQ
    | ADD_ASSIGN
    | SUBTRACT_ASSIGN
    | MULTIPLY_ASSIGN
    | DIVIDE_ASSIGN
    | MODULO_ASSIGN
    ;

arguments
    : argument
    | arguments COMMA argument
    ;

argument
    : expression
    ;

%%

#include "lex.yy.c"

char *file_path;

int main(int argc, char *argv[]) {
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
    if (!yyparse()) {
        printf("\nParsing complete.\n");
    } else {
        printf("\nParsing failed.\n");
    }
    fclose(yyin);
    return 0;
}

void yyerror(const char *msg) {
    fflush(stdout);
    fprintf(stderr, "%s:%d:%d: %s\n\t%s\n\n", file_path, yylineno, column, msg, yytext);
}
