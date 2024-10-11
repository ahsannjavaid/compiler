#include <stdio.h>
#include <string>
#include <map>
#include <vector>

// Structure to represent each element in the array with its value, tag, and min/max value constraints.
struct ArrayElement {
    double value;        // Value of the array element
    std::string tag;     // Tag associated with the array element (for filtering)
    double minValue;     // Minimum allowed value for the element
    double maxValue;     // Maximum allowed value for the element
};

// Symbol tables for managing arrays and scalar variables
static std::map<std::string, std::vector<ArrayElement>> arraySymbolTable;         // 1D array symbol table
static std::map<std::string, std::vector<std::vector<ArrayElement>>> array2DSymbolTable; // 2D array symbol table
static std::map<std::string, double> symbolTable;                                 // Symbol table for scalar variables

// Function to perform basic arithmetic operations (+, -, *, /) on two operands
double performBinaryOperation(double lhs, double rhs, int op) {
    switch (op) {
        case '+':
            return lhs + rhs;   // Addition
        case '-':
            return lhs - rhs;   // Subtraction
        case '*':
            return lhs * rhs;   // Multiplication
        case '/':
            return lhs / rhs;   // Division
        default:
            return 0;           // Invalid operation
    }
}

// 1D Array Functions

// Declare a 1D array in the symbol table with a given size and value constraints (minValue, maxValue)
void declareArrayInSymbolTable(const char* id, int size, double minValue, double maxValue) {
    std::string name(id);  // Convert C-string to C++ string
    arraySymbolTable[name] = std::vector<ArrayElement>(size, {0.0, "", minValue, maxValue});  // Initialize array with default values
}

// Set the value and tag of an element in a 1D array
void setArrayValueInSymbolTable(const char* id, int index, double value, const char* tag) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {  // Check if the array exists in the symbol table
        if (value != 0.0) {  // Set the value only if it's non-zero
            // Ensure the value is within the allowed range
            if (value <= arraySymbolTable[name][0].maxValue && value >= arraySymbolTable[name][0].minValue) 
                arraySymbolTable[name][index].value = value;
            else 
                printf("%s range is MIN=%.2f and MAX=%.2f. You have assigned=%.2f.\n", id, arraySymbolTable[name][0].minValue, arraySymbolTable[name][0].maxValue, value);
        }
        arraySymbolTable[name][index].tag = tag;  // Set the tag for the element
    }
}

// Retrieve the value of an element in a 1D array
double getArrayValueFromSymbolTable(const char* id, int index) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {
        return arraySymbolTable[name][index].value;  // Return the value of the array element
    }
    return 0;  // Return default value if the array or index is not found
}

// 2D Array Functions

// Declare a 2D array in the symbol table with a given size and value constraints
void declare2DArrayInSymbolTable(const char* id, int size1, int size2, double minValue, double maxValue) {
    std::string name(id);
    array2DSymbolTable[name] = std::vector<std::vector<ArrayElement>>(size1, std::vector<ArrayElement>(size2, {0.0, "", minValue, maxValue}));  // Initialize 2D array
}

// Set the value and tag of an element in a 2D array
void set2DArrayValueInSymbolTable(const char* id, int index1, int index2, double value, const char* tag) {
    std::string name(id);
    if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {  // Check if the 2D array exists
        if (value != 0.0) {  // Set the value only if it's non-zero
            // Ensure the value is within the allowed range
            if (value <= array2DSymbolTable[name][0][0].maxValue && value >= array2DSymbolTable[name][0][0].minValue) 
                array2DSymbolTable[name][index1][index2].value = value;
            else 
                printf("%s range is MIN=%.2f and MAX=%.2f. You have assigned=%.2f.\n", id, array2DSymbolTable[name][0][0].minValue, array2DSymbolTable[name][0][0].maxValue, value);
        }
        array2DSymbolTable[name][index1][index2].tag = tag;  // Set the tag for the element
    }
}

// Retrieve the value of an element in a 2D array
double get2DArrayValueFromSymbolTable(const char* id, int index1, int index2) {
    std::string name(id);
    if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {
        return array2DSymbolTable[name][index1][index2].value;  // Return the value of the 2D array element
    }
    return 0;  // Return default value if the array or index is not found
}

// Scalar Variables

// Set a scalar variable's value in the symbol table
void setValueInSymbolTable(const char* id, double value) {
    std::string name(id);
    symbolTable[name] = value;  // Store the variable value in the symbol table
}

// Retrieve a scalar variable's value from the symbol table
double getValueFromSymbolTable(const char* id) {
    std::string name(id);
    if (symbolTable.find(name) != symbolTable.end()) {
        return symbolTable[name];  // Return the variable's value
    }
    return 0;  // Return default value if the variable is not found
}

// Filter and print array elements (both 1D and 2D arrays) by tag
void filterArrayByTag(const char* id, const char* tag) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {  // Check if it's a 1D array
        for (int i = 0; i < arraySymbolTable[name].size(); i++) {
            if (arraySymbolTable[name][i].tag == tag) {  // If tag matches, print the element's value
                printf("%.2f\n", arraySymbolTable[name][i].value);
            }
        }
    }
    else if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {  // Check if it's a 2D array
        for (int i = 0; i < array2DSymbolTable[name].size(); i++) {
            for (int j = 0; j < array2DSymbolTable[name][i].size(); j++) {
                if (array2DSymbolTable[name][i][j].tag == tag) {  // If tag matches, print the element's value
                    printf("%.2f\n", array2DSymbolTable[name][i][j].value);
                }
            }
        }
    }
    else {
        printf("Array '%s' not found.\n", id);  // Array not found in either 1D or 2D symbol tables
    }
}
