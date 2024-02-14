Program Description
Write and test a MASM program to perform the following tasks (check the Requirements section for specifics on program modularization):

Introduce the program.
Declare global constants ARRAYSIZE, LO, and HI. Generate ARRAYSIZE random integers in the range from LO to HI (inclusive), storing them in consecutive elements of array randArray. (e.g. for LO = 20 and HI = 30, generate values from the set [20, 21, ... 30]) 
ARRAYSIZE should be initially set to 200,
LO should be initially set to 15
HI should be initially set to 50
Hint: Call Randomize once in main to generate a random seed. Later, use RandomRange to generate each random number.
Display the list of integers before sorting, 20 numbers per line with one space between each value.
Sort the list in ascending order (i.e., smallest first).
Calculate and display the median value of the sorted randArray, rounded to the nearest integer. (Using Round Half UpLinks to an external site. rounding)
Display the sorted randArray, 20 numbers per line with one space between each value.
Generate an array counts which holds the number of times each value in the range [LO, HI] ([15, 50] for default constant values) is seen in randArray, even if the number of times a value is seen is zero.
For example with LO=15, counts[0] should equal the number of instances of the value `15` in array. counts[14] should equal the number of instances of the value `29` in randArray. Note that some value may appear zero times and should be reported as zero instances.
Display the array counts, 20 numbers per line with one space between each value.
Program Requirements
The program must be constructed using procedures. At least the following procedures/parameters are required:
NOTE: Regarding the syntax used below...
procName {parameters: varA (value, input), varB (reference, output)} indicates that procedure procName must be passed varA as a value and varB as a reference, and that varA is an input parameter and varB is an output parameter. You may use more parameters than those specified but try to only use them if you need them.
main
introduction {parameters: intro1 (reference, input), intro2 (reference, input), ...)
fillArray {parameters: someArray (reference, output)}  NOTE: LO, HI, ARRAYSIZE will be used as globals within this procedure.
sortList {parameters: someArray (reference, input/output)} NOTE: ARRAYSIZE will be used as a global within this procedure.
exchangeElements (if your sorting algorithm exchanges element positions): {parameters: someArray[i] (reference. input/output), someArray[j] (reference, input/output), where i and j are the indexes of elements to be exchanged}
displayMedian {parameters: someTitle (reference, input), someArray (reference, input)} NOTE: ARRAYSIZE will likely be used as a global within this procedure.
displayList {parameters: someTitle (reference, input), someArray (reference, input), arrayLength (value, input)} 
countList {parameters: someArray1 (reference, input), someArray2 (reference, output)} NOTE: LO, HI, and ARRAYSIZE will be used as globals within this procedure.
Procedures (except main) must not reference data segment variables by name. There is a significant penalty attached to violations of this rule.  randArray, counts, titles for the sorted/unsorted lists, etc... should be declared in the .data preceding main, but must be passed to procedures on the stack.
Constants LO, HI, and ARRAYSIZE may be used as globals. 
Parameters must be passed on the system stack, by value or by reference, as noted above (see Module 7, Exploration 1 - Passing Parameters on the Stack for method).
Strings/arrays must be passed by reference.
Since you will not be using globals (except the constants) the program must use one (or more) of the addressing modes from the explorations (e.g. Register Indirect or Indirect Operands addressing for reading/writing array elements, and Base+Offset addressing for accessing parameters on the runtime stack.)
See Module 7, Exploration 2 - Arrays in Assembly and Writing to Memory for details.
The programmer’s name and program title, and a description of program functionality (in student's own words) to the user must appear in the output.
LO, HI, and ARRAYSIZE must be declared as constants.
NOTE: We will be changing these constant values to ensure they are implemented correctly. Expect ranges as follows
LO: 5 to 20
HI: 30 to 60 
ARRAYSIZE: 20 to 1000
There must be only one procedure to display arrays. This procedure must be called three times:
to display the unsorted array
to display the sorted array
to display the counts array
All lists must be identified when they are displayed (use the someTitle parameter for the displayList procedure).
Procedures may use local variables when appropriate.
The program must be fully documented and laid out according to the CS271 Style Guide. This includes a complete header block for identification, description, etc., a comment outline to explain each block of code, and proper procedure headers/documentation.
