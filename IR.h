#include <stdio.h>
#include <string>
#include <map>
#include <vector>

// This is symbol table data structure.
static std::map<std::string, std::vector<double>> arraySymbolTable;
static std::map<std::string, std::vector<std::vector<double>>> array2DSymbolTable;
static std::map<std::string, double> symbolTable;

double performBinaryOperation(double lhs, double rhs, int op) {
    switch (op) {
        case '+':
            return lhs + rhs;
        case '-':
            return lhs - rhs;
        case '*':
            return lhs * rhs;
        case '/':
            return lhs / rhs;
        default:
            return 0;
    }
}

// 1D Array Functions
void declareArrayInSymbolTable(const char* id, int size) {
    std::string name(id);
    arraySymbolTable[name] = std::vector<double>(size, 0);
}

void setArrayValueInSymbolTable(const char* id, int index, double value) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {
        arraySymbolTable[name][index] = value;
    }
}

double getArrayValueFromSymbolTable(const char* id, int index) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {
        return arraySymbolTable[name][index];
    }
    return 0; // Default value
}

// 2D Array Functions
void declare2DArrayInSymbolTable(const char* id, int size1, int size2) {
    std::string name(id);
    array2DSymbolTable[name] = std::vector<std::vector<double>>(size1, std::vector<double>(size2, 0));
}

void set2DArrayValueInSymbolTable(const char* id, int index1, int index2, double value) {
    std::string name(id);
    if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {
        array2DSymbolTable[name][index1][index2] = value;
    }
}

double get2DArrayValueFromSymbolTable(const char* id, int index1, int index2) {
    std::string name(id);
    if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {
        return array2DSymbolTable[name][index1][index2];
    }
    return 0; // Default value
}

// Scalar variables
void setValueInSymbolTable(const char* id, double value) {
    std::string name(id);
    symbolTable[name] = value;
}

double getValueFromSymbolTable(const char* id) {
    std::string name(id);
    if (symbolTable.find(name) != symbolTable.end()) {
        return symbolTable[name];
    }
    return 0; // Default value
}

