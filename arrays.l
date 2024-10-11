%{
  	#include "arrays.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
	#include <string>
	extern void yyerror(const char *msg);  // Error handling function declaration
%}

%option yylineno
%option noyywrap

DIGIT     [0-9]
ID        [a-zA-Z_][a-zA-Z0-9_]*
WS        [ \t]+
NEWLINE   [\n\r]+

%%

{NEWLINE}           { return NEWLINE; }  // Match and return newline
"double"            { return DOUBLE; }   // Match keyword "double" and return the corresponding token
"array"             { return ARRAY; }    // Match keyword "array"
"set_tag"           { return SET_TAG; }  // Match keyword "set_tag"
"filter_by_tag"     { return FILTER_BY_TAG; }  // Match keyword "filter_by_tag"
"print"		    { return PRINT; }  // Match keyword "print"
"//".*              { /* Ignore single-line comments */ }
{ID}                { yylval.identifier=strdup(yytext); return IDENTIFIER; }  // Match identifier and store its value in yylval
"["                 { return OPEN_BRACKET; }  // Match opening bracket '['
{DIGIT}+(\.{DIGIT}+)? { yylval.double_literal=atof(yytext); return NUMBER; }  // Match a number, convert to double, and return as NUMBER token
"]"                 { return CLOSE_BRACKET; }  // Match closing bracket ']'
":"		    { return COLON; }  // Match colon ':'
","		    { return COMMA; }  // Match comma ','

{WS}                /* ignore whitespace */ ; 

"+"|"-"|"*"|"\/"|"="|";"|"("|")"	{ return yytext[0]; }

.                   { yyerror("This is an illegal lexeme."); exit(EXIT_FAILURE); }

%%
