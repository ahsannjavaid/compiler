%{
  /* C code or headers included here */
#include "IR.h"
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE 100

typedef struct {
    double value;
    char *tag;
} TaggedElement;

typedef struct {
    TaggedElement elements[MAX_SIZE];
    int count;
} TaggedArray;

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

TaggedArray tagged_array; // Global tagged array

// Function to filter elements by tag
void filter_by_tag(const char *tag);

%}

%union {
	char *identifier;
	double double_literal;
	int int_literal;
}

%token <identifier> IDENTIFIER
%token <double_literal> NUMBER

%type <double_literal> term expr array_access array_elements
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
  | array_definition
  | tag_assignment
  | filtering_operation
  ;

declaration:
  DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET    {
    declareArrayInSymbolTable($3, (int) $5);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET {
    declare2DArrayInSymbolTable($3, (int) $5, (int) $8);
  }
  ;

assignment:
  IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET '=' expr {
    setArrayValueInSymbolTable($1, $3, $6);  // Fixed types for 1D array
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET '=' expr {
    set2DArrayValueInSymbolTable($1, $3, $6, $9);  // Handle 2D array assignment
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
    printf("%lf\n", $3);
  }
  ;
  
array_definition:
    ARRAY OPEN_BRACKET array_elements CLOSE_BRACKET
    {
        printf("Array created with %d elements.\n", tagged_array.count);
    }
;  

array_elements:
    NUMBER
    {
        if (tagged_array.count < MAX_SIZE) {
            tagged_array.elements[tagged_array.count].value = $1; // Use $1 for NUMBER value
            tagged_array.elements[tagged_array.count].tag = NULL; // Initialize tag to NULL
            tagged_array.count++;
        }
        $$ = tagged_array.count; // Return the current count of elements
    }
    | array_elements COMMA NUMBER
    {
        if (tagged_array.count < MAX_SIZE) {
            tagged_array.elements[tagged_array.count].value = $3; // Use $3 for NUMBER value
            tagged_array.elements[tagged_array.count].tag = NULL; // Initialize tag to NULL
            tagged_array.count++;
        }
        $$ = tagged_array.count; // Return the current count of elements
    }
    ;
  
tag_assignment:
    SET_TAG IDENTIFIER COLON NUMBER
    {
        for (int i = 0; i < tagged_array.count; i++) {
            if (tagged_array.elements[i].value == $4) {
                tagged_array.elements[i].tag = strdup($2);
                printf("Tag '%s' assigned to element %.2f\n", $2, $4);
                break;
            }
        }
    }
    ;
  
filtering_operation:
    FILTER_BY_TAG IDENTIFIER
    {
        filter_by_tag($2);
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

void filter_by_tag(const char *tag) {
    printf("Filtered elements with tag '%s': ", tag);
    for (int i = 0; i < tagged_array.count; i++) {
        if (tagged_array.elements[i].tag != NULL && strcmp(tagged_array.elements[i].tag, tag) == 0) {
            printf("%.2f ", tagged_array.elements[i].value);
        }
    }
    printf("\n");
}

int main(int argc, char *argv[]) {
  tagged_array.count = 0; // Initialize the tagged array
  yyin = fopen(argv[1], "r");
  if (!yyin) {
    fprintf(stderr, "Error opening file\n");
    return 1;
  }
  yyparse();
  fclose(yyin);
  return 0;
}

