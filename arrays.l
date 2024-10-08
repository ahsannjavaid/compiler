%{
  	#include "arrays.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
	#include <string>
	extern void yyerror(const char *msg);
%}

%option yylineno
%option noyywrap

DIGIT     [0-9]
ID        [a-zA-Z_][a-zA-Z0-9_]*
WS        [ \t]+
NEWLINE   [\n\r]+

%%

{NEWLINE}           { return NEWLINE; }
"double"            { return DOUBLE; }
"array"             { return ARRAY; }
"set_tag"           { return SET_TAG; }
"filter_by_tag"     { return FILTER_BY_TAG; }
"print"		    { return PRINT; }
"//".*              { /* Ignore single-line comments */ }
{ID}                { yylval.identifier=strdup(yytext); return IDENTIFIER; }
"["                 { return OPEN_BRACKET; }
{DIGIT}+(\.{DIGIT}+)? { yylval.double_literal=atof(yytext); return NUMBER; }
"]"                 { return CLOSE_BRACKET; }
":"		    { return COLON; }
","		    { return COMMA; }

{WS}                /* ignore whitespace */ ;
"+"|"-"|"*"|"\/"|"="|";"|"("|")"	{ return yytext[0]; } 
.                   { yyerror("this is a illegal lexeme"); exit(EXIT_FAILURE); }  // Catch-all rule moved to the bottom

%%

  /* User-defined functions, such as `yywrap()` or helper functions */
