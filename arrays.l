%{
  #include "arrays.tab.h"
%}

%option noyywrap

DIGIT     [0-9]
ID        [a-zA-Z_][a-zA-Z0-9_]*
WS        [ \t]+
NEWLINE   [\n\r]+

%%

{NEWLINE}           { printf("NEWLINE\n"); return NEWLINE; }
"double"            { printf("DOUBLE\n"); return DOUBLE; }
"array"             { printf("ARRAY\n"); return ARRAY; }
{ID}                { printf("IDENTIFIER: %s\n", yytext); return IDENTIFIER; }
"["                 { printf("OPEN_BRACKET\n"); return OPEN_BRACKET; }
{DIGIT}+(\.{DIGIT}+)? { printf("NUMBER: %s\n", yytext); return NUMBER; }
"]"                 { printf("CLOSE_BRACKET\n"); return CLOSE_BRACKET; }
{WS}                /* ignore whitespace */ ;
.                   return yytext[0];  // Catch-all rule moved to the bottom

%%

  /* User-defined functions, such as `yywrap()` or helper functions */
