%{
extern int column;
int yylex();
void yyerror(const char *msg);
void debug(const char *msg);
%}


%union {
    char *string_val;
    char *num_val;
}

%token VAR
%token LET
%token CONST
%token FUNCTION
%token ARROW_FUNCTION                   //  =>
%token SEMICOLON                        //  ;
%token COLON                            //  :
%token IDENTIFIER
%token FOR
%token WHILE
%token IF
%token ELSE
%token RETURN
%token SWITCH
%token CASE
%token DEFAULT
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
%token LPAREN                           //  (
%token RPAREN                           //  )
%token LBRACE                           //  {
%token RBRACE                           //  }
%token LBRACKET                         //  [
%token RBRACKET                         //  ]
%token <string_val> LITERAL_TRUE        //  true
%token <string_val> LITERAL_FALSE       //  false
%token <num_val> LITERAL_NAN            //  NaN
%token <num_val> LITERAL_INFINITY       //  Infinity
%token <string_val> LITERAL_NULL        //  null
%token <string_val> LITERAL_UNDEFINED   //  undefined
%token DQUOTE
%token SQUOTE
%token TQUOTE
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token ASSIGN                           //  =
%token EQ                               //  ==
%token EXACTLY_EQ                       //  ===
%token NOT_EQ                           //  !=
%token EXACTLY_NOT_EQ                   //  !==
%token NOT                              //  !
%token DOT                              //  .
%token AND                              //  &
%token OR                               //  |
%token COMMA                            //  ,
%token MODULO                           //  %
%token TERNARY                          //  ?
%token INCREASE                         //  ++
%token DECREASE                         //  --
%token ADD_ASSIGN                       //  +=
%token SUBTRACT_ASSIGN                  //  -=
%token MULTIPLY_ASSIGN                  //  *=
%token DIVIDE_ASSIGN                    //  /=
%token MODULO_ASSIGN                    //  %=
%token LT                               //  <
%token GT                               //  >
%token LTE                              //  <=
%token GTE                              //  >=
%token STRICT_MODE                      //  "use strict";
%token <num_val> NUMBER
%token <string_val> STRING

%error-verbose

%%

script
    : statements
    ;

statements
    : statement
    | statements statement
    ;

value_literal
    : STRING
    | LITERAL_FALSE
    | LITERAL_TRUE
    | NUMBER
    | LITERAL_NAN
    | LITERAL_INFINITY
    | LITERAL_NULL
    | LITERAL_UNDEFINED
    ;

array_literal
    : LBRACKET RBRACKET
    | LBRACKET array_elements RBRACKET
    ;

array_elements
    : assignment_expression
    | array_elements COMMA assignment_expression
    ;

object_literal
    : LBRACE RBRACE
    ;

primary_expression
    : IDENTIFIER
    | value_literal
    | array_literal
    | object_literal
    | LPAREN expression RPAREN
    | function_declaration { debug("function declaration") }
    | function_declaration SEMICOLON { debug("function declaration") }
    ;

function_declaration
    : FUNCTION IDENTIFIER LPAREN arguments RPAREN scope
    | FUNCTION LPAREN arguments RPAREN scope
    | LPAREN arguments RPAREN ARROW_FUNCTION scope
    ;

postfix_expression
    : primary_expression
    | postfix_expression LPAREN RPAREN
    | postfix_expression LPAREN arguments RPAREN
    | postfix_expression DOT postfix_expression
    | postfix_expression INCREASE
    | postfix_expression DECREASE
    /* | postfix_expression LBRACKET expression RBRACKET */
    ;

unary_expression
    : postfix_expression
    | unary_operator unary_expression
    ;

multiplicative_expression
    : unary_expression
    | multiplicative_expression multiplicative_operator unary_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression additive_operator multiplicative_expression
    ;

relational_expression
    : additive_expression
    | relational_expression relational_operator additive_expression
    ;

equality_expression
    : relational_expression
    | equality_expression equality_operator relational_expression
    ;

logical_and_expression
    : equality_expression
    | logical_and_expression AND equality_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR logical_and_expression
    ;

conditional_expression
    : logical_or_expression
    | logical_or_expression TERNARY assignment_expression COLON conditional_expression
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression { debug("expression"); }
    ;

expression
    : assignment_expression
    | expression ',' assignment_expression
    ;

statement
    : expression_statement
    | for_statement
    | while_statement
    | if_statement
    | jump_statement
    | declaration
    | STRICT_MODE { debug("strict mode enabled") }
    ;

expression_statement
    : expression { debug("expression statement"); }
    | expression SEMICOLON { debug("expression statement"); }
    | SEMICOLON
    ;

if_statement
    : IF LPAREN assignment_expression RPAREN scope ELSE scope { debug("if-else statement"); }
    | IF LPAREN assignment_expression RPAREN scope { debug("if statement"); }
    ;

for_statement
    : FOR LPAREN declaration SEMICOLON expression SEMICOLON expression RPAREN scope { debug("for statement"); }
    ;

while_statement
    : WHILE LPAREN expression RPAREN scope { debug("while statement"); }
    ;

switch_statement
    : SWITCH LPAREN expression RPAREN { debug("switch statement"); }
    ;

switch_body
    : LBRACE case_statements RBRACE
    ;

case_statements
    : /* None */
    | case_statement
    | case_statements case_statement
    ;

case_statement
    : CASE IDENTIFIER COLON statements
    | DEFAULT COLON statements
    ;

jump_statement
    : BREAK { debug("break"); }
    | BREAK SEMICOLON { debug("break"); }
    | CONTINUE { debug("continue"); }
    | CONTINUE SEMICOLON { debug("continue"); }
    | RETURN expression_statement { debug("return"); }
    ;

scope
    : LBRACE statements RBRACE { debug("scope"); }
    ;

declaration
    : variable_declaration { debug("variable declaration") }
    | variable_declaration SEMICOLON { debug("variable declaration") }
    ;

variable_declaration
    : type_specifier IDENTIFIER
    | type_specifier IDENTIFIER ASSIGN expression
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

multiplicative_operator
    : MULTIPLY
    | DIVIDE
    | MODULO
    ;

additive_operator
    : PLUS
    | MINUS
    ;

relational_operator
    : LT
    | LTE
    | GT
    | GTE
    ;

equality_operator
    : EQ
    | NOT_EQ
    | EXACTLY_EQ
    | EXACTLY_NOT_EQ
    ;

assignment_operator
    : ASSIGN
    | ADD_ASSIGN
    | SUBTRACT_ASSIGN
    | MULTIPLY_ASSIGN
    | DIVIDE_ASSIGN
    | MODULO_ASSIGN
    ;

arguments
    : argument
    | arguments COMMA argument
    |
    ;

argument
    : assignment_expression
    | function_declaration
    ;

%%

#include <stdio.h>
#include "lex.yy.c"

void debug(const char *msg) {
    printf("debug: %s at line %d\n", msg, yylineno);
}

char *file_path;

int main(int argc, char *argv[]) {
    #if YYDEBUG == 1
    yydebug = 1;
    #endif

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
    fprintf(stderr, "%s:%d:%d: %s\n\t%s\n\n", file_path, yylineno, (int) (column - yyleng), msg, yytext);
}
