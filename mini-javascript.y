%{
extern int column;
int yylex();
void yyerror(const char *msg);
void debug(const char *msg);
%}


%union {
    char *boolean_val;
    char *undefined_val;
    char *object_val;
    char *string_val;
    char *number_val;
}

%type <string_val> identifier

%token VAR
%token LET
%token CONST
%token FUNCTION
%token ARROW_FUNCTION                   //  =>
%token SEMICOLON                        //  ;
%token COLON                            //  :
%token FOR
%token WHILE
%token DO
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
%token TYPEOF
%token INSTANCEOF
%token ASYNC
%token AWAIT
%token LPAREN                           //  (
%token RPAREN                           //  )
%token LBRACE                           //  {
%token RBRACE                           //  }
%token LBRACKET                         //  [
%token RBRACKET                         //  ]
%token <boolean_val> LITERAL_TRUE        //  true
%token <boolean_val> LITERAL_FALSE       //  false
%token <number_val> LITERAL_NAN            //  NaN
%token <number_val> LITERAL_INFINITY       //  Infinity
%token <string_val> LITERAL_NULL        //  null
%token <string_val> LITERAL_UNDEFINED   //  undefined
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
%token <number_val> NUMBER
%token <string_val> STRING
%token <string_val> IDENTIFIER

%error-verbose

%%

script
    : statements
    ;

statements
    : statement
    | statements statement
    ;

identifier
    : IDENTIFIER { $$ = $1; }
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
    | LBRACE object_pair RBRACE
    ;

object_pair
    : object_key COLON assignment_expression
    | object_pair COMMA object_key COLON assignment_expression
    ;

object_key
    : STRING
    | NUMBER
    ;

primary_expression
    : identifier
    | value_literal
    | array_literal
    | object_literal
    | LPAREN expression RPAREN
    | function_declaration { debug("function declaration") }
    ;

function_declaration
    : FUNCTION IDENTIFIER LPAREN arguments RPAREN scope
    | FUNCTION LPAREN arguments RPAREN scope
    | LPAREN arguments RPAREN ARROW_FUNCTION scope
    | ASYNC FUNCTION IDENTIFIER LPAREN arguments RPAREN scope
    | ASYNC FUNCTION LPAREN arguments RPAREN scope
    | ASYNC LPAREN arguments RPAREN ARROW_FUNCTION scope
    ;

postfix_expression
    : primary_expression
    | primary_expression INCREASE
    | primary_expression DECREASE
    | postfix_expression DOT primary_expression
    | postfix_expression LPAREN RPAREN
    | postfix_expression LPAREN arguments RPAREN
    /* | postfix_expression LBRACKET expression RBRACKET */
    ;

unary_expression
    : postfix_expression
    | unary_operator unary_expression
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
    | relational_expression LT additive_expression
    | relational_expression LTE additive_expression
    | relational_expression GT additive_expression
    | relational_expression GTE additive_expression
    ;

equality_expression
    : relational_expression
    | equality_expression EQ relational_expression
    | equality_expression NOT_EQ relational_expression
    | equality_expression EXACTLY_EQ relational_expression
    | equality_expression EXACTLY_NOT_EQ relational_expression
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
    | expression COMMA assignment_expression
    ;

statement
    : expression_statement
    | for_statement
    | while_statement
    | do_while_statement
    | if_statement
    | switch_statement
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
    : WHILE LPAREN assignment_expression RPAREN scope { debug("while statement"); }
    ;

do_while_statement
    : DO scope WHILE LPAREN assignment_expression RPAREN SEMICOLON { debug("do-while statement") }
    ;

switch_statement
    : SWITCH LPAREN assignment_expression RPAREN switch_body { debug("switch statement"); }
    ;

switch_body
    : LBRACE RBRACE
    | LBRACE case_statements RBRACE
    ;

case_statements
    : case_statement
    | case_statements case_statement
    ;

case_statement
    : CASE assignment_expression COLON statements
    | CASE assignment_expression COLON case_statement
    | DEFAULT COLON statements
    ;

jump_statement
    : BREAK skippable_semicolon { debug("break"); }
    | CONTINUE skippable_semicolon { debug("continue"); }
    | RETURN { debug("return"); }
    | RETURN expression_statement { debug("return"); }
    ;

scope
    : LBRACE RBRACE { debug("empty scope"); }
    | LBRACE statements RBRACE { debug("scope"); }
    ;

declaration
    : variable_declaration skippable_semicolon { debug("variable declaration") }
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
    | NEW
    | DELETE
    | INSTANCEOF
    | TYPEOF
    | AWAIT
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
    ;

skippable_semicolon
    : /* Empty */
    | SEMICOLON
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
