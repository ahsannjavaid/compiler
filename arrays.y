%{
  /* C code or headers included here */
#include "IR.h"
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

%}

%union {
	char *identifier;
	double double_literal;
	int int_literal;
}

%token <identifier> IDENTIFIER
%token <double_literal> NUMBER

%type <double_literal> term expr array_access
%type <int_literal> array_index

%left '+' '-' 
%left '*' '/'
%left '(' ')'

%token DOUBLE ARRAY SET_TAG FILTER_BY_TAG PRINT OPEN_BRACKET CLOSE_BRACKET COMMA COLON NEWLINE

%start program

%%

program:
  program statement NEWLINE
  | statement NEWLINE
  ;

statement:
  declaration
  | assignment
  | array_access
  | print_statement
  | tag_assignment
  | filtering_operation
  ;

declaration:
  DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET    {
    declareArrayInSymbolTable($3, (int) $5, 0.0, 100000.0);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET {
    declare2DArrayInSymbolTable($3, (int) $5, (int) $8, 0.0, 100000.0);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET '(' NUMBER COMMA NUMBER ')' {
    declareArrayInSymbolTable($3, (int) $5, $8, $10);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET '(' NUMBER COMMA NUMBER ')' {
    declare2DArrayInSymbolTable($3, (int) $5, (int) $8, $11, $13);
  }
  ;

assignment:
  IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET '=' expr {
    setArrayValueInSymbolTable($1, $3, $6, "");  // Fixed types for 1D array
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET '=' expr {
    set2DArrayValueInSymbolTable($1, $3, $6, $9, "");  // Handle 2D array assignment
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET '=' expr COLON IDENTIFIER {
    setArrayValueInSymbolTable($1, $3, $6, $8);  // Fixed types for 1D array
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET '=' expr COLON IDENTIFIER {
    set2DArrayValueInSymbolTable($1, $3, $6, $9, $11);  // Handle 2D array assignment
  }
  | IDENTIFIER '=' expr {
    setValueInSymbolTable($1, $3);
  }
  ;

array_access:
  IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET {
    $$ = getArrayValueFromSymbolTable($1, $3);
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET {
    $$ = get2DArrayValueFromSymbolTable($1, $3, $6);
  }
  ;

print_statement:
  PRINT '(' expr ')' {
    printf("%.2f\n", $3);
  }
  ;
  
tag_assignment:
    SET_TAG IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET COLON IDENTIFIER {
	setArrayValueInSymbolTable($2, $4, 0.0, $7);  // Fixed types for 1D array
    }
    | SET_TAG IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET COLON IDENTIFIER {
	set2DArrayValueInSymbolTable($2, $4, $7, 0.0, $10);  // Fixed types for 1D array
    }
    ;
  
filtering_operation:
    FILTER_BY_TAG IDENTIFIER IDENTIFIER
    {
        filterArrayByTag($3, $2);
    }
    ;

term:
  IDENTIFIER {
    $$ = getValueFromSymbolTable($1);
  } 
  | NUMBER {
    $$ = $1;
  }
  ;

array_index:
  NUMBER {
    $$ = (int) $1;
  }
  ;

expr:
   term { $$ = $1; }
   | array_access { $$ = $1; }
   | expr '+' expr { $$ = performBinaryOperation($1, $3, '+'); }
   | expr '-' expr { $$ = performBinaryOperation($1, $3, '-'); }
   | expr '*' expr { $$ = performBinaryOperation($1, $3, '*'); }
   | expr '/' expr { $$ = performBinaryOperation($1, $3, '/'); }
   | '(' expr ')' { $$ = $2; }
   ;	   

%%

void yyerror(const char *s) {
  extern int yylineno;
  extern char *yytext;
  fprintf(stderr, "Error: %s at line %d near '%s'\n", s, yylineno, yytext);
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

