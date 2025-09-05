1. What is meant by filtering a list? Give an example that uses a built-in filter function in the language of your choice.
 Filtering a list means to iterate through the list and create a new list based on elements in the original list that meet certain criteria. The old list will still exist provided you assign the filtered list to a different list name than the original. 

const numbers = [1,2,3,4,5,6,7,8,9,10,-1,-2,0]
const evenNumbers = numbers.filter(num => num % 2 ===0);
console.log(evenNumbers)

2. Give a compact Julia expression for the array just like the array called numbers except that every value is cubed. Use broadcasting.
numbers = [1,2,3,4,5,6,0,-1,-2]
println( (x -> x^3).(numbers) )



3. What is meant by the phrase “pragmatics of programming languages”?
“Pragmatics of programming languages” is a phrase that asks what does a programming language value? What is its intended use (for machine learning, data analysis, theorem proving)? Is it verbose or concise? It describes the language beyond “it's so annoying”, or “it's hard to read”. 


4. Explain, in detail, this fragment of K: {+/x[&x!2]^2}
It first does modular arithmetic on x to find out whether the element in the list is even (0) or odd (1). It then indices where the odd numbers are by ‘finding’ the 1’s. It then takes those x values that resulted in a 1 after modular arithmetic and squares them. It then sums them. 


5. What does the term object-orientation mean today? What did it originally mean?
Object oriented programming today describes a programming paradigm that emphasizes classes and inheritance. For example, in python, classes serve as a blueprint for creating objects that inherit methods and attributes from the class. Those objects are units that can be modified by methods belonging to the class. They are instances of the class, and in many languages signal a hierarchy of sorts. Alan Kay meant that each object was its own mini ‘agent’ that could only communicate with other objects by passing messages. Classes were a convenient way to make similar objects. They all did their own tasks and processes individually and sent information to other objects when necessary. In our investigation, the concept of message passing was heavily emphasized. Modern OOP objects are usually instances of a class and have a usualy hierarchy to them (in most languages), and their relationship is often the center of communication. Whereas as Kay envisioned, each object does a task and can communicate without needing things like methods. In other words, objects didn't need to share a common “parent” to talk. OOP today reflects a focus on classes and shared features, while Kay viewed it more as a bunch of communicating agents/objects. 


6. What characters comprise the following string: ᐊᐃᓐᖓᐃ? List the code point and name of each character that appears, in order. What is the meaning of the string, assuming its intended context?
ᐊ = U+140A = CANADIAN SYLLABICS A
ᐃ = U+1403 = CANADIAN SYLLABICS I
ᓐ = U+14D0 = CANADIAN SYLLABICS N
ᖓ = U+15D3 = CANADIAN SYLLABICS NGA
ᐃ = U+1403 = CANADIAN SYLLABICS I
this string spells out ainngi which means no or not. Negation.

7. What is the difference between control flow and concurrency?
control flow is the order which instructions are exectuted. this is the path of exectution. While concurrency is the ability to execute multiple proccesses simultaneously. concurrency is about managing multiple paths at once or in one time.

8. How do machine and assembly languages differ? Give an example that is different from the one seen in class.

9. We saw, in class, a function that computed either or depending on whether 
is even or odd. Write this function in a programming language not seen in class.

10. The language Verse is billed as a functional-logic programming languages. Write a short paragraph about Verse, including its creator, year of creation, why it was created, and what exactly “functional-logic” means.