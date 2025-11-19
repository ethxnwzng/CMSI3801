1) Explain the meaning of each of the following C declarations.

double *a[n];

a is an array of size n where each element of a is a pointer to a double.

double (*b)[n];

b is a pointere to an array of n doubles.

double (*c[n])();

c is an array of size n where each element of c is a pointer to a function that returns a double. it takes unspecified arguements.

double (*d())[n];

d is a function that takes no arguements and returns a pointer to an array of n doubles.

2) In C, when exactly do arrays decay to pointers?

typically an array decays into a pointer at the first element. there are exceptions to the rule though. when you use sizeOf(arr), &arr or string literals the compiler does not decay these. in all other use cases the compiler decays these.

3) Give a short description, under 10 words each, of the following, as they are understood in the context of the C language: 

(a) memory leak

Allocated memory that is not properly released.

(b) dangling pointer

pointer refrencing freed or invalid memory.

(c) double free

freeing the same memory block twice.

(d) buffer overflow

writing beyond allocated buffer boundaries.

(e) stack overflow

exceeding stack memory capacity during execution.

(f) wild pointer

uninitialized or invalid pointer to unkown memory.

4) Explain why C++ move constructors and move assignment operators only make sense on r-values and not l-values. You can use a rough code fragment in your explanation.

move operators are only able to steal resources from temporaries/disposables aka (r-values). l-values are persistent so moving them would invalidate usable objects.

5) Why does C++ even have moves, anyway?

For Efficiency, Resource Transfer and Temporary Optimization. C++ has moves to eliminate unneccesary expensivive copies and enable safe transfer of ownership. they make the code more expressive, especially with temporaries and resource management classes. 

6) What is the rule-of-5 in C++?

the rule-of-5 is used for labeling all of your member functions in a class. If your class is managing resources you should label the destructor, copy constructor, copy assignment, move constructor and move assignment operator

Destructor Cleans up resources when the object goes out of scope.

Copy Constructor Defines how to create a new object as a copy of another.

Copy Assignment Operator Defines how to assign one existing object to another.

Move Constructor Defines how to construct a new object by stealing resources from a temporary (r-value).

Move Assignment Operator Defines how to assign by stealing resources from a temporary (r-value).

This matters because if your class is managing resources you need to be very careful about controlling how these resources are copied, moved and destroyed. The rule states that you need to define all of these in order to help avoid memory leaks, double frees and other kinds of bugs. This rule ensures safe and consistent code.

7) What are the three ownership rules of Rust?

Rust ownership rules:

Each value has one owner.
Owners scope defines lifetime.
Ownership transfers on assignment or passing.

8) What are the three borrowing rules of Rust?

Rust borrowing rules:

You can have either many immuntable refrences or one mutable refrence.
Refrences must not outlive their data.
No mixing mutable and immutable borrows simultaneously.
