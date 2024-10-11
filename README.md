"# Compiler - Arrays"

## Course & Group Info
### Course
**Title:** Compiler Construction
**Instructor:** Dr. Faisal Aslam

### Group
**Number:** Group 3
**Topic:** Arrays
**Functionalities**
1) `Basic Array Functionalities:` 1D and 2D Arrays
2) `Additional Unique Feature:` Tagged Array
2) `Additional Unique Feature:` Bounded Arrays with Constraints

### Group Members
1) Hafiz Waleed Asif    (21L-7602)
2) Saad Ahmad           (21L-7645)
3) Ahsan Javed          (21L-1815)

### Work Division
**Ahsan Javed**, `Basic Array Functionalities:` Project Setup, 1D and 2D Arrays, Merging Additional Features
**Saad Ahmed**, `Additional Unique Feature:` Tagged Array
**Hafiz Waleed Asif**, `Additional Unique Feature:` Bounded Arrays with Constraints

## Technologies
1) **FLEX** (Scanner/Lexer)
2) **Bison** (Parser)

## Compilation and Execution
### How to Compile?
Make sure you have FLEX and Bison installed. The make file has been prepared. Follow the following steps to compile the code:
1) Open Terminal in root directory of the project.
2) Type 'make', and code will start compiling.

### How to Run/Execute?
Follow following steps to execute the code:
1) Type 'make run'. You will see the output.

### Input file (input.txt)
The compiler will compile the **input.txt** file. You can make changes in it to test the functionalities.

## Additional Unique Features Details
### Tagged Array
**Detail:** We can assign a tag to each value of arrays. Then we can filter the values of arrays based on a particular tag.

**Syntax1:** `ARRAY_NAME[INDEX] = VALUE : TAG`
**Syntax1:** `set_tag ARRAY_NAME[INDEX] : TAG`
**Example1:** `arr[2] = 1.0 : positive`
**Example1:** `set_tag arr[2] : positive`

For filtering the values based on tags:
**Syntax:** `filter_by_tag TAG ARRAY_NAME`
**Example:** `filter_by_tag positive arr`

### Bounded Arrays with Constraints
**Detail:** We can set limits/boundaries/range of values while declaring array. Maximum and Minimum value. If the value is less than or greater than the minimum and maximum allowed value of array respectively, user will see error and the value will set to 0.

**Syntax:** `double array ARRAY_NAME[SIZE](MIN_VALUE, MAX_VALUE)`
**Example:** `double array arr[10](2, 10)`

