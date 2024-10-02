%{
  #include "y.tab.h"
%}

%option noyywrap

DIGIT     [0-9]
ID        [a-zA-Z_][a-zA-Z0-9_]*
WS        [ \t]+
NEWLINE   [\n\r]+

%%

"double"            return DOUBLE;
"array"             return ARRAY;
{ID}                return IDENTIFIER;
"["                 return OPEN_BRACKET;
"]"                 return CLOSE_BRACKET;
":"                 return SLICE;
{DIGIT}+(\.{DIGIT}+)?    return NUMBER;
{WS}                /* ignore whitespace */;
{NEWLINE}           return NEWLINE;
.                   return yytext[0];

%%

  /* User-defined functions, such as `yywrap()` or helper functions */
int yywrap() {
  return 1;
}