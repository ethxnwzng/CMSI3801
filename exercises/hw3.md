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
a) 
left false
left true
right ()

b)
false
true
()



4. (a) Which are the inhabitants of bool x unit (b) Which are the inhabitants of bool -> unit?
a)
(true, ())
(false, ())

b)
λb.()

5. What are the major arguments put forward in the article The String Type is Broken?

6. Can you give a type to (λx. (x x))(λx. (x x)) If so, what is it? If not, why not?
No, we cannot give this a type because its a self application or omega combinator which a problem with systems types. This is a circular type problem so its like A = A -> B which is not possible.

7. Represent x ∉ A in function notation.
λx.¬A(x)

8. What is a pure function? Why do we care about these things?
a function that always produces the same output for the same input(deterministic), doesnt modify anything outside its scope, and only depends on its parameters. We care about pure functions because they are easier to test, can be safely executed in parallel without race conditions, results can be cached since same input = same output, easy to combine, and have no hidden dependencies or unexpected behavior.
9. How does Haskell isolate pure and impure code?
through the IO monad. the IO monad type system prevents calling impure functions from pure code, you must explicitly handle IO types to perform side effects. 
10. In TypeScript, which of | or & is closer to the idea of “subclassing” or “inheritance” from Python? Why? (An example will help!)
& is closer to subclassing/inheritance from python. & combine multiple types into one, giving it all properties fro both types. While | represents either/or relationships.