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

Control flow is the sequential order that a program executes instructions in, determning which statement will run next in the code. Concurrency is the computers ability to execute mulitple processes at the same time, allowing better runtime because multiple tasks can be completed together. 

8. How do machine and assembly languages differ? Give an example that is different from the one seen in class.

Machine language is made up of binary, the lowest level of information for the computer that the CPU executes directly from. Assembly language is a higher up language that uses human mnemonics and symbols to give meaning to the lower level computer-understood information. An assembler is required to take the human understood written code and make it understandable to the machine. 

ex: 
To add two numbers in machine language in 8-bit: 00000011 00000001 00000010
In assembly language: ADD AX, BX

9. We saw, in class, a function that computed either or depending on whether is even or odd. Write this function in a programming language not seen in class.

C#:
using System;

class Program 
{
    static string EvenOrOdd(int n) 
    {
        return n % 2 == 0 ? "even" : "odd";
    }
    
    static void Main() 
    {
        Console.WriteLine(EvenOrOdd(4));  
    }
}

10. The language Verse is billed as a functional-logic programming languages. Write a short paragraph about Verse, including its creator, year of creation, why it was created, and what exactly “functional-logic” means.

Verse is a language created about Epic Games in 2023 for using Unreal Engine. The language was made under Tim Sweeney and his team including Simon Peyton Jones, Lennart Augustsson...It was created to be a better expressive scripting solution for interactive, real-time quick update games and experiences (Fortnite creative). The creators also extended the capability of the language to be used for metaverse (VR-chat) like enviornments with real-time like interactions. "Functional logic" in the Verse language states that functional programming: bringing features like higher-order functions, immutability for variables, and static coding, and logic programming: concepts such as equality constraints and backtracking allows for programmers to reason about their systems similar to how one does mathematics (article says "lambda calculus"). Overall, Verse is a combination of functional and logic programming made by Epic Games for safe and highly concurrent scripting for game developer. 

Source: https://simon.peytonjones.org/assets/pdfs/verse-March23.pdf?utm_source=chatgpt.com


Ethan-https://docs.google.com/document/d/1xNQtGTHIpq0Kb9Az1-OXM18JjQUBXed1C6VEPSY4z-Y/edit?tab=t.0
Westley - https://docs.google.com/document/d/1Tpttas4tEG7jjdJajyxvpcRQkvyYT2gChDd_-4r-E7g/edit?tab=t.0
Nick - https://docs.google.com/document/d/1_61HE3RPuk8KHhhK9X9Jm4z7j6BNnx8DQzP28jo1m2w/edit?tab=t.0