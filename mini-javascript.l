%{
#include <stdio.h>
#include <stdlib.h>

int column;
void yyerror(const char *s);
void count();

// enum TOKEN {
//     TOKEN_EOF, VAR, LET, CONST, FUNCTION, ARROW_FUNCTION, SEMICOLON, COLON, IDENTIFIER,
//     FOR, WHILE, DO, IF, ELSE, SWITCH, CASE, BREAK, CONTINUE, NEW, DELETE,
//     LPAREN, RPAREN, LBRACE, RBRACE, LBRACKET, RBRACKET, INSTANCEOF, IN, OF, THIS,
//     LITERAL_TRUE, LITERAL_FALSE, LITERAL_NAN, LITERAL_NULL, LITERAL_UNDEFINED,
//     DQUOTE, SQUOTE, TQUOTE,
//     PLUS, MINUS, MULTIPLY, DIVIDE, EQ, NOT_EQ, NOT, DOT, AND, OR, COMMA, MODULO, TERNARY, INCREASE, DECREASE,
//     ADD_ASSIGN, SUBTRACT_ASSIGN, MULTIPLY_ASSIGN, DIVIDE_ASSIGN, MODULO_ASSIGN,
//     LT, GT, LTE, GTE, NUMBER STRING
// };

%}

letter [a-zA-Z_$]
digit  [0-9]
space [" "\t\r]

%%
var                             { count(); return VAR; }
let                             { count(); return LET; }
const                           { count(); return CONST; }
function                        { count(); return FUNCTION; }
"=>"                            { count(); return ARROW_FUNCTION; }
for                             { count(); return FOR; }
while                           { count(); return WHILE; }
do                              { count(); return DO; }
if                              { count(); return IF; }
else                            { count(); return ELSE; }
return                          { count(); return RETURN; }
switch                          { count(); return SWITCH; }
case                            { count(); return CASE; }
default                         { count(); return DEFAULT; }
break                           { count(); return BREAK; }
continue                        { count(); return CONTINUE; }
new                             { count(); return NEW; }
delete                          { count(); return DELETE; }
instanceof                      { count(); return INSTANCEOF; }
in                              { count(); return IN; }
of                              { count(); return OF; }
this                            { count(); return THIS; }
async                           { count(); return ASYNC; }
await                           { count(); return AWAIT; }

true                            {
                                    count();
                                    yylval.string_val = "true";
                                    return LITERAL_TRUE;
                                }
false                           {
                                    count();
                                    yylval.string_val = "false";
                                    return LITERAL_FALSE;
                                }
NaN                             {
                                    count();
                                    yylval.num_val = "NaN";
                                    return LITERAL_NAN;
                                }
NULL                            {
                                    count();
                                    yylval.string_val = "null";
                                    return LITERAL_NULL;
                                }
UNDEFINED                       {
                                    count();
                                    yylval.string_val = "undefined";
                                    return LITERAL_UNDEFINED;
                                }

\"                              { count(); return DQUOTE; }
\'                              { count(); return SQUOTE; }
\`                              { count(); return TQUOTE; }
";"                             { count(); return SEMICOLON; }
":"                             { count(); return COLON; }
"("                             { count(); return LPAREN; }
")"                             { count(); return RPAREN; }
"{"                             { count(); return LBRACE; }
"}"                             { count(); return RBRACE; }
"["                             { count(); return LBRACKET; }
"]"                             { count(); return RBRACKET; }

"+"                             { count(); return PLUS; }
"-"                             { count(); return MINUS; }
"*"                             { count(); return MULTIPLY; }
"/"                             { count(); return DIVIDE; }
"%"                             { count(); return MODULO; }
"="                             { count(); return ASSIGN; }
"=="                            { count(); return EQ; }
"==="                           { count(); return EXACTLY_EQ; }
"!="                            { count(); return NOT_EQ; }
"!=="                           { count(); return EXACTLY_NOT_EQ; }
"&&"                            { count(); return AND; }
"||"                            { count(); return OR; }
"!"                             { count(); return NOT; }
"<"                             { count(); return LT; }
">"                             { count(); return GT; }
"<="                            { count(); return LTE; }
">="                            { count(); return GTE; }
","                             { count(); return COMMA; }
"?"                             { count(); return TERNARY; }
"++"                            { count(); return INCREASE; }
"--"                            { count(); return DECREASE; }

"+="                            { count(); return ADD_ASSIGN; }
"-="                            { count(); return SUBTRACT_ASSIGN; }
"*="                            { count(); return MULTIPLY_ASSIGN; }
"/="                            { count(); return DIVIDE_ASSIGN; }
"%="                            { count(); return MODULO_ASSIGN; }

\.                              { count(); return DOT; }

Infinity                        {
                                    count();
                                    yylval.num_val = "Infinity";
                                    return LITERAL_INFINITY;
                                }
{letter}({letter}|{digit})*     {
                                    count();
                                    yylval.string_val = strdup(yytext);
                                    return IDENTIFIER;
                                }
{digit}+                        {
                                    count();
                                    yylval.num_val = strdup(yytext);
                                    return NUMBER;
                                }
{digit}+\.{digit}+              {
                                    count();
                                    yylval.num_val = strdup(yytext);
                                    return NUMBER;
                                }

\"[^"]*\"                       {
                                    count();
                                    yylval.string_val = strdup(yytext);
                                    return STRING;
                                }
\'[^']*\'                       {
                                    count();
                                    yylval.string_val = strdup(yytext);
                                    return STRING;
                                }
\`[^`]*\`                       {
                                    count();
                                    yylval.string_val = strdup(yytext);
                                    return STRING;
                                }

^\'use[ ]strict\';              { count(); return STRICT_MODE; }
^\"use[ ]strict\";              { count(); return STRICT_MODE; }
"//".*                          { count(); }
{space}                         { count(); }
\n                              { count(); }
.                               { count(); yyerror("Invalid token"); }
%%

int yywrap() {
    return 1;
}

void count() {
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') {
            yylineno++;
            column = 0;
        } else {
            column++;
        }
    }
}

/* int main() {
    printf("JavaScript Lexer\n\n");

    enum TOKEN token;
    while (!!(token = yylex()) != TOKEN_EOF) {
        if (token == ERR) {
            printf("Error occurred at line %d - \"%s\"\n", yylineno, yytext);
        } else {
            printf("%s recognized\n", yytext);
        }
    }
    return 0;
} */
