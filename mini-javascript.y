%{
#include <stdio.h>
#include "parser.h"
%}


%union {
    char *val;
    node *node;
}

%type <val>     value_literal object_literal array_literal type_specifier
%type <node>    script statements statement scope
                if_statement for_statement jump_statement while_statement do_while_statement expression_statement
                expression primary_expression assignment_expression conditional_expression postfix_expression
                equality_expression relational_expression additive_expression multiplicative_expression unary_expression
                logical_or_expression logical_and_expression
                variable_declaration function_declaration parameters

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
%token <val> LITERAL_TRUE               //  true
%token <val> LITERAL_FALSE              //  false
%token <val> LITERAL_NAN                //  NaN
%token <val> LITERAL_INFINITY           //  Infinity
%token <val> LITERAL_NULL               //  null
%token <val> LITERAL_UNDEFINED          //  undefined
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
%token <val> NUMBER
%token <val> STRING
%token <val> IDENTIFIER

/* %parse-param {node *root} */
%error-verbose

%%

script
    : statements { root = put_node(Program, NULL, NULL, NULL, $1); }
    ;

statements
    : statement
    | statements statement { $$ = sibling_node($1, $2); }
    ;

value_literal
    : STRING { debug("string literal", $$); }
    | LITERAL_FALSE { debug("boolean: false literal", $$); }
    | LITERAL_TRUE { debug("boolean: true literal", $$); }
    | NUMBER { debug("number literal", $$); }
    | LITERAL_NAN { debug("number: NaN literal", $$); }
    | LITERAL_INFINITY { debug("number: Infinity literal", $$); }
    | LITERAL_NULL { debug("object: null literal", $$); }
    | LITERAL_UNDEFINED { debug("undefined literal", $$); }
    ;

array_literal
    : LBRACKET RBRACKET { $$ = "[]"; debug("array: [] literal", $$); }
    | LBRACKET array_elements RBRACKET {}
    ;

array_elements
    : assignment_expression
    | array_elements COMMA assignment_expression
    ;

object_literal
    : LBRACE RBRACE { $$ = "{}"; }
    | LBRACE object_pair RBRACE {}
    ;

object_pair
    : object_key COLON assignment_expression
    | object_pair COMMA object_key COLON assignment_expression
    | object_pair COMMA
    ;

object_key
    : STRING
    | NUMBER
    | IDENTIFIER
    ;

primary_expression
    : IDENTIFIER { $$ = identifier_node($1, 1); }
    | value_literal { $$ = literal_node($1); }
    | array_literal { $$ = literal_node($1); }
    | object_literal { $$ = literal_node($1); }
    | LPAREN expression RPAREN
    | function_declaration { debug("function declaration", ""); }
    ;

function_declaration
    : FUNCTION IDENTIFIER LPAREN parameters RPAREN scope { $$ = function_node($2, 0, $4, $6); }
    | FUNCTION LPAREN parameters RPAREN scope { $$ = function_node(NULL, 0, $3, $5); }
    | LPAREN parameters RPAREN ARROW_FUNCTION scope { $$ = function_node(NULL, 0, $2, $5); }
    | ASYNC FUNCTION IDENTIFIER LPAREN parameters RPAREN scope { $$ = function_node($3, 1, $5, $7); }
    | ASYNC FUNCTION LPAREN parameters RPAREN scope { $$ = function_node(NULL, 1, $4, $6); }
    | ASYNC LPAREN parameters RPAREN ARROW_FUNCTION scope { $$ = function_node(NULL, 1, $3, $6); }
    ;

postfix_expression
    : primary_expression
    | primary_expression INCREASE { debug("postfix increase", ""); }
    | primary_expression DECREASE { debug("postfix decrease", ""); }
    | postfix_expression DOT primary_expression
    | postfix_expression LPAREN RPAREN
    | postfix_expression LPAREN arguments RPAREN
    | postfix_expression LBRACKET expression RBRACKET { debug("member access", ""); }
    ;

unary_expression
    : postfix_expression
    | NOT unary_expression
    | NEW unary_expression
    | DELETE unary_expression
    | INSTANCEOF unary_expression
    | TYPEOF unary_expression
    | AWAIT unary_expression
    ;

multiplicative_expression
    : unary_expression
    | multiplicative_expression MULTIPLY unary_expression { operator_node("*", $1, $3); debug("multiply expression", ""); }
    | multiplicative_expression DIVIDE unary_expression { operator_node("/", $1, $3); debug("divide expression", ""); }
    | multiplicative_expression MODULO unary_expression { operator_node("%", $1, $3); debug("modulo expression", ""); }
    ;

additive_expression
    : multiplicative_expression
    | additive_expression PLUS multiplicative_expression { $$ = operator_node("+", $1, $3); }
    | additive_expression MINUS multiplicative_expression { $$ = operator_node("-", $1, $3); }
    ;

relational_expression
    : additive_expression
    | relational_expression LT additive_expression { $$ = operator_node("<", $1, $3); }
    | relational_expression LTE additive_expression { $$ = operator_node("<=", $1, $3); }
    | relational_expression GT additive_expression { $$ = operator_node(">", $1, $3); }
    | relational_expression GTE additive_expression {$$ = operator_node(">=", $1, $3); }
    | relational_expression INSTANCEOF additive_expression {}
    ;

equality_expression
    : relational_expression
    | equality_expression EQ relational_expression { $$ = operator_node("==", $1, $3); debug("equal expression", ""); }
    | equality_expression NOT_EQ relational_expression { $$ = operator_node("!=", $1, $3); debug("not equal expression", ""); }
    | equality_expression EXACTLY_EQ relational_expression { $$ = operator_node("===", $1, $3); debug("exactly equal expression", ""); }
    | equality_expression EXACTLY_NOT_EQ relational_expression { $$ = operator_node("!==", $1, $3); debug("exactly not equal expression", ""); }
    ;

logical_and_expression
    : equality_expression
    | logical_and_expression AND equality_expression { $$ = operator_node("&&", $1, $3); debug("logical and expression", ""); }
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR logical_and_expression { $$ = operator_node("||", $1, $3); debug("logical or expression", ""); }
    ;

conditional_expression
    : logical_or_expression
    | logical_or_expression TERNARY assignment_expression COLON conditional_expression { debug("conditional expression", ""); }
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression { $$ = operator_node("=", $1, $3); debug("assignment expression", ""); }
    ;

expression
    : assignment_expression
    | expression COMMA assignment_expression { $$ = sibling_node($1, $3); }
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
    | STRICT_MODE { strict_mode = 1; debug("strict mode enabled", ""); }
    ;

expression_statement
    : expression
    | expression SEMICOLON
    | SEMICOLON
    ;

if_statement
    : IF LPAREN assignment_expression RPAREN scope ELSE scope { debug("if-else statement", ""); }
    | IF LPAREN assignment_expression RPAREN scope { debug("if statement", ""); }
    ;

for_statement
    : FOR LPAREN variable_declaration SEMICOLON assignment_expression SEMICOLON assignment_expression RPAREN scope { debug("for statement", ""); }
    | FOR LPAREN assignment_expression SEMICOLON assignment_expression SEMICOLON assignment_expression RPAREN scope { debug("for statement", ""); }
    ;

while_statement
    : WHILE LPAREN assignment_expression RPAREN scope { debug("while statement", ""); }
    ;

do_while_statement
    : DO scope WHILE LPAREN assignment_expression RPAREN SEMICOLON { debug("do-while statement", ""); }
    ;

switch_statement
    : SWITCH LPAREN assignment_expression RPAREN switch_body { debug("switch statement", ""); }
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
    : BREAK skippable_semicolon { $$ = jump_node("break", NULL); debug("break", ""); }
    | CONTINUE skippable_semicolon { $$ = jump_node("continue", NULL); debug("continue", ""); }
    | RETURN { $$ = jump_node("return", NULL); debug("return", ""); }
    | RETURN expression_statement { $$ = jump_node("return", $2); debug("return", ""); }
    ;

scope
    : LBRACE RBRACE { $$ = NULL; debug("empty scope", ""); }
    | LBRACE statements RBRACE { $$ = $2; }
    ;

declaration
    : variable_declaration skippable_semicolon
    ;

variable_declaration
    : type_specifier IDENTIFIER { $$ = identifier_node($2, !strcmp($1, "const")); debug("variable declaration", $2); }
    | type_specifier IDENTIFIER ASSIGN expression   {
                                                        $$ = identifier_node($2, strcmp($1, "const"));
                                                        debug("variable declaration with value", $2);
                                                        $$->child = $4;
                                                    }
    ;

type_specifier
    : VAR { $$ = strdup("var"); }
    | LET { $$ = strdup("let"); }
    | CONST { $$ = strdup("const"); }
    ;

assignment_operator
    : ASSIGN
    | ADD_ASSIGN
    | SUBTRACT_ASSIGN
    | MULTIPLY_ASSIGN
    | DIVIDE_ASSIGN
    | MODULO_ASSIGN
    ;

parameters
    : /* None */ { $$ = NULL; debug("empty function parameter", ""); }
    | IDENTIFIER { $$ = identifier_node($1, 1); debug("function parameter", $1); }
    | parameters COMMA IDENTIFIER {
                                $$ = sibling_node($1, identifier_node($3, 1));
                            }
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
