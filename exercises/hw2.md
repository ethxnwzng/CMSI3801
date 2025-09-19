1. Why is the null reference so hideous?

Because it introduces all sorts of errors, such as, null dereference errors. These errors are usually hard to find and debug. When we try to access a method on a null reference it crashes leaving us with possible security vulnerabilities. The null reference in all just added extra headache where it's un-needed.


2. Why did Tony Hoare introduce the null reference, even though he felt like it was wrong and his friend Edsger Dijkstra said it was a bad idea?

He introduced the null reference to simplify the design of ALGOL W language and its compiler. He needed a way to represent the nothingness or absence of an object. Hoare prioritized simplicity for safety even though he knew it was a bad idea and Edsger Dijkstra told him so.


3. In JavaScript 3**35 = 50031545098999710 but in Python 3**35 = 50031545098999707. 

Which one is right and which is wrong? Why? Explain exactly why the right value is right and the wrong value is that particular wrong value.
Python is right and JS is wrong. Python is right because it uses arbitrary-precision integers so it's computed exactly. While Javascript uses IEEE 754 double precision floating point numbers which cannot accurately represent or calculate larger numbers.
 
4. What is the Python equivalent of JavaScript’s {x: 3, [y]: 5, z}?

The technical equivalent in python is {'x': 3, y: 5, 'z': z}. This is because in JS we have an object with a property named “x” with value 3, another property with the value of variable y with value 5 and a property named “z” with the value of variable z. These are interchangeable because both JavaScript objects and Python dictionaries allow you to mix fixed string keys and keys from variables.




5. Why is it best to not call JavaScript’s == operator “equals” (even though people do it all the time)?

It's best not to call this operator equals because this tries to perform type coercion before comparison. This means that 0 == “0” is true but 0 === “0” is false. True equality comes from the triple equals.


6. Write a Lua function called arithmeticsequence that accepts two arguments, start and delta, that returns a coroutine such that each time it is resumed it yields the next value in the arithmetic sequence starting with start and incrementing by delta.


function arithmeticsequence(start, delta)
    return coroutine.create(function()
        local value = start
        while true do
            coroutine.yield(value)
            value = value + delta
        end
    end)
end

7. What does this script print under (a) static scoping and (b) dynamic scoping?

A. static scoping:
f() always returns the global x (1), because its reference to x is resolved where f is defined. h() calls g(), which defines x = 3 locally, but then calls f(), which again returns the global x (1).
So: f() is 1, h() is 1, global x is 1.
Output: 
1×1−1=0
1×1−1=0
B. dynamic scoping:
f() returns the value of x in the calling environment.
When f() is called from the global scope, it returns global x (1). When f() is called from g(), which is called from h(), the most recent x in the call stack is x = 3 (from g()).
So: f() is 1, h() is 3, global x is 1.
Output: 
1×3−1=2
1×3−1=2


8. Why does shallow binding not make much sense when combined with static scoping?
This doesn't make sense because static scoping determines variable bindings based on the program's structure at definition time not at runtime. Because shallow binding is all about using the most recent environment when the procedure is called since static binding uses the environment where the procedure is called this would mean shallow binding has no effect.
