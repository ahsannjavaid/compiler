%{
  /* C code or headers included here */
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

%}

//%token TOKEN1 TOKEN2  /* Token declarations */
%token DOUBLE ARRAY IDENTIFIER OPEN_BRACKET CLOSE_BRACKET SLICE NUMBER NEWLINE

%%

  /* Grammar rules and associated actions */
program:
  program statement NEWLINE
  | statement NEWLINE
  ;

statement:
  declaration
  | assignment
  | array_access
  | array_slice
  ;

declaration:
  DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET    { printf("Declaring a single-dimensional array\n"); }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET   { printf("Declaring a double-dimensional array\n"); }
  ;

assignment:
  array_access '=' expr	{ printf("Assigning value to array\n"); }
  | IDENTIFIER '=' expr      { printf("Assigning value to variable\n"); }
  ;

array_access:
  IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET    { printf("Accessing array element at index\n"); }
  | IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET   { printf("Accessing 2D array element at index\n"); }
  ;

array_slice:
  IDENTIFIER OPEN_BRACKET NUMBER ':' NUMBER CLOSE_BRACKET   { printf("Array slicing\n"); }
  ;

expr:
  NUMBER
  | IDENTIFIER
  ;


%%

  /* User-defined functions such as `main()`, `yyerror()`, etc. */
void yyerror(const char *s) {
  extern int yylineno;  // Line number from lexer
  fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
}

int main(int argc, char *argv[]) {
  yyin = fopen(argv[1], "r");
  if (!yyin) {
    fprintf(stderr, "Error opening file\n");
    return 1;
  }
  yyparse();
  fclose(yyin);
  return 0;
}
