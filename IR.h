#include <stdio.h>
#include <string>
#include <map>
#include <vector>

struct ArrayElement {
    double value;
    std::string tag;
};

// This is symbol table data structure.
static std::map<std::string, std::vector<ArrayElement>> arraySymbolTable;
static std::map<std::string, std::vector<std::vector<ArrayElement>>> array2DSymbolTable;
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
    arraySymbolTable[name] = std::vector<ArrayElement>(size, {0.0, ""});
}

void setArrayValueInSymbolTable(const char* id, int index, double value, const char* tag) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {
        if (value != 0.0) arraySymbolTable[name][index].value = value;
        arraySymbolTable[name][index].tag = tag; // Setting tag
    }
}

double getArrayValueFromSymbolTable(const char* id, int index) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {
        return arraySymbolTable[name][index].value;
    }
    return 0; // Default value
}

// 2D Array Functions
void declare2DArrayInSymbolTable(const char* id, int size1, int size2) {
    std::string name(id);
    array2DSymbolTable[name] = std::vector<std::vector<ArrayElement>>(size1, std::vector<ArrayElement>(size2, {0.0, ""}));
}

void set2DArrayValueInSymbolTable(const char* id, int index1, int index2, double value, const char* tag) {
    std::string name(id);
    if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {
        if (value != 0.0) array2DSymbolTable[name][index1][index2].value = value;
        array2DSymbolTable[name][index1][index2].tag = tag;
    }
}

double get2DArrayValueFromSymbolTable(const char* id, int index1, int index2) {
    std::string name(id);
    if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {
        return array2DSymbolTable[name][index1][index2].value;
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

void filterArrayByTag(const char* id, const char* tag) {
    std::string name(id);
    if (arraySymbolTable.find(name) != arraySymbolTable.end()) {
        //printf("Filtered elements with tag '%s':\n", tag);
        for (int i = 0; i < arraySymbolTable[name].size(); i++) {
            if (arraySymbolTable[name][i].tag == tag) {
                //printf("Index %d: %.2f\n", i, arraySymbolTable[name][i].value);
                printf("%.2f\n", arraySymbolTable[name][i].value);
            }
        }
    }
    else if (array2DSymbolTable.find(name) != array2DSymbolTable.end()) {
        for (int i = 0; i < array2DSymbolTable[name].size(); i++) {
            for (int j = 0; j < array2DSymbolTable[name][i].size(); j++) {
                if (array2DSymbolTable[name][i][j].tag == tag) {
                    //printf("Index %d: %.2f\n", i, arraySymbolTable[name][i].value);
                    printf("%.2f\n", array2DSymbolTable[name][i][j].value);
                }
            }
        }
    }
    else {
        printf("Array '%s' not found.\n", id);
    }
}

