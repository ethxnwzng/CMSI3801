1. Show how to constructively define the type of trees of elements of type t.
t : Type
────────────────────────────── 
Tree(t) : Type

────────────────────────────── 
Empty : Tree(t)

x : t    l : Tree(t)    r : Tree(t)
────────────────────────────────────── 
Node(x, l, r) : Tree(t)

2. Give a definition by cases for the exponentiation of natural numbers.
exp :: Nat -> Nat -> Nat
exp _ Zero = Succ Zero
exp base (Succ n) = mult base (exp base n)

3. (a) Which are the inhabitants of bool+unit? (b) Which are the inhabitants of bool | unit?

4. (a) Which are the inhabitants of bool x unit (b) Which are the inhabitants of bool -> unit?

5. What are the major arguments put forward in the article The String Type is Broken?

6. Can you give a type to (λx. (x x))(λx. (x x)) If so, what is it? If not, why not?
no we cant give this a type because its a self application or omega combinator which a problem with systems types. this is a circular type problem so its like A = A -> B which is not possible.
7. Represent x ∉ A in function notation.

8. What is a pure function? Why do we care about these things?

9. How does Haskell isolate pure and impure code?

10. In TypeScript, which of | or & is closer to the idea of “subclassing” or “inheritance” from Python? Why? (An example will help!)
