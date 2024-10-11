%{

#include "IR.h"
#include <stdlib.h>
#include <string.h>

extern int yylex();    // External lexer function to generate tokens
extern int yyparse();   // External parser function to parse input
extern FILE *yyin;      // Input file for the lexer/parser
void yyerror(const char *s);  // Error handling function

%}

%union {
	char *identifier;      // For identifiers (e.g., variable names)
	double double_literal; // For double/float numbers
	int int_literal;       // For integer literals
}

%token <identifier> IDENTIFIER     // Token for identifiers (variable/array names)
%token <double_literal> NUMBER     // Token for numeric literals

%type <double_literal> term expr array_access // Non-terminals that evaluate to double values
%type <int_literal> array_index               // Non-terminal for array indices

%left '+' '-'  // Left-associative operators for addition and subtraction
%left '*' '/'  // Left-associative operators for multiplication and division
%left '(' ')'  // Parentheses for grouping expressions

%token DOUBLE ARRAY SET_TAG FILTER_BY_TAG PRINT OPEN_BRACKET CLOSE_BRACKET COMMA COLON NEWLINE // Keywords and symbols used in grammar

%start program  // Starting rule of the grammar

%%

program:
  program statement NEWLINE // Program consists of multiple statements, each ending with a newline
  | statement NEWLINE       // Single statement ending with a newline
  ;

statement:
  declaration              // Variable or array declaration statement
  | assignment             // Assignment statement
  | array_access           // Accessing an array value
  | print_statement        // Print statement for output
  | tag_assignment         // Assigning a tag to an array element
  | filtering_operation    // Filtering array elements by tag
  ;

declaration:
  DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET    {
    // Declaration of 1D array with size and default min/max values
    declareArrayInSymbolTable($3, (int) $5, 0.0, 100000.0);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET {
    // Declaration of 2D array with size and default min/max values
    declare2DArrayInSymbolTable($3, (int) $5, (int) $8, 0.0, 100000.0);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET '(' NUMBER COMMA NUMBER ')' {
    // Declaration of 1D array with custom min/max values
    declareArrayInSymbolTable($3, (int) $5, $8, $10);
  }
  | DOUBLE ARRAY IDENTIFIER OPEN_BRACKET NUMBER CLOSE_BRACKET OPEN_BRACKET NUMBER CLOSE_BRACKET '(' NUMBER COMMA NUMBER ')' {
    // Declaration of 2D array with custom min/max values
    declare2DArrayInSymbolTable($3, (int) $5, (int) $8, $11, $13);
  }
  ;

assignment:
  IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET '=' expr {
    // Assignment of a value to a 1D array element without a tag
    setArrayValueInSymbolTable($1, $3, $6, "");
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET '=' expr {
    // Assignment of a value to a 2D array element without a tag
    set2DArrayValueInSymbolTable($1, $3, $6, $9, "");
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET '=' expr COLON IDENTIFIER {
    // Assignment of a value to a 1D array element with a tag
    setArrayValueInSymbolTable($1, $3, $6, $8);
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET '=' expr COLON IDENTIFIER {
    // Assignment of a value to a 2D array element with a tag
    set2DArrayValueInSymbolTable($1, $3, $6, $9, $11);
  }
  | IDENTIFIER '=' expr {
    // Assignment of a value to a scalar variable
    setValueInSymbolTable($1, $3);
  }
  ;

array_access:
  IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET {
    // Accessing a value from a 1D array
    $$ = getArrayValueFromSymbolTable($1, $3);
  }
  | IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET {
    // Accessing a value from a 2D array
    $$ = get2DArrayValueFromSymbolTable($1, $3, $6);
  }
  ;

print_statement:
  PRINT '(' expr ')' {
    // Print the evaluated expression result
    printf("%.2f\n", $3);
  }
  ;
  
tag_assignment:
    SET_TAG IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET COLON IDENTIFIER {
    // Assign a tag to a 1D array element
	setArrayValueInSymbolTable($2, $4, 0.0, $7);
    }
    | SET_TAG IDENTIFIER OPEN_BRACKET array_index CLOSE_BRACKET OPEN_BRACKET array_index CLOSE_BRACKET COLON IDENTIFIER {
    // Assign a tag to a 2D array element
	set2DArrayValueInSymbolTable($2, $4, $7, 0.0, $10);
    }
    ;
  
filtering_operation:
    FILTER_BY_TAG IDENTIFIER IDENTIFIER
    {
        // Filter array elements by a given tag
        filterArrayByTag($3, $2);
    }
    ;

term:
  IDENTIFIER {
    // Fetch the value of a scalar variable
    $$ = getValueFromSymbolTable($1);
  } 
  | NUMBER {
    // Return numeric literal
    $$ = $1;
  }
  ;

array_index:
  NUMBER {
    // Convert number to integer for array indexing
    $$ = (int) $1;
  }
  ;

expr:
   term { $$ = $1; }                     // Expression is either a term (identifier or number)
   | array_access { $$ = $1; }           // Expression can also be an array access
   | expr '+' expr { $$ = performBinaryOperation($1, $3, '+'); } // Binary operation (addition)
   | expr '-' expr { $$ = performBinaryOperation($1, $3, '-'); } // Binary operation (subtraction)
   | expr '*' expr { $$ = performBinaryOperation($1, $3, '*'); } // Binary operation (multiplication)
   | expr '/' expr { $$ = performBinaryOperation($1, $3, '/'); } // Binary operation (division)
   | '(' expr ')' { $$ = $2; }           // Parenthesized expressions for precedence
   ;	   

%%

// Error handling function that prints the error message, line number, and problematic token
void yyerror(const char *s) {
  extern int yylineno;
  extern char *yytext;
  fprintf(stderr, "Error: %s at line %d near '%s'\n", s, yylineno, yytext);
}

// Main function to open a file, start parsing, and close the file
int main(int argc, char *argv[]) {
  yyin = fopen(argv[1], "r");  // Open the input file
  if (!yyin) {                 // Handle file open error
    fprintf(stderr, "Error opening file\n");
    return 1;
  }
  yyparse();                   // Parse the input
  fclose(yyin);                // Close the input file
  return 0;                    // Exit program
}
