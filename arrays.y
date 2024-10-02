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
  DOUBLE ARRAY IDENTIFIER '[' NUMBER ']'    { printf("Declaring a single-dimensional array\n"); }
  | DOUBLE ARRAY IDENTIFIER '[' NUMBER ']' '[' NUMBER ']'   { printf("Declaring a double-dimensional array\n"); }
  ;

assignment:
  IDENTIFIER '=' expr      { printf("Assigning value to variable\n"); }
  ;

array_access:
  IDENTIFIER '[' NUMBER ']'    { printf("Accessing array element at index\n"); }
  | IDENTIFIER '[' NUMBER ']' '[' NUMBER ']'   { printf("Accessing 2D array element at index\n"); }
  ;

array_slice:
  IDENTIFIER '[' NUMBER ':' NUMBER ']'   { printf("Array slicing\n"); }
  ;

expr:
  NUMBER
  | IDENTIFIER
  ;


%%

  /* User-defined functions such as `main()`, `yyerror()`, etc. */
void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
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