1) In Java, which keywords (if any) are used to indicate a class may have (a) no instances, (b) only a fixed number of instances, (c) no subclasses, (d) only a fixed number of subclasses.

a) In java the keyword to indicate a class will not have any instances is "abstract". Essentially you cannot create objects of this class.

b) The keyword for defining a class with only a fixed number of instances is "enum". enum defines a class with a fixed set of instances (its constants)

c) The keyword for used for no subclasses is called "final". A final class cannot be subclassed

d) Only a fixed number of classes keyword is "sealed". A sealed class restricts which classes may extend it

2) Very briefly, list the four main differences between a Swift class and a Swift struct.

- Value vs. reference: structs are value types (copied on assignment); classes are reference types (shared references).
- Inheritance: classes support subclassing; structs do not (both can conform to protocols).
- Mutation & initialization: struct methods that modify self must be marked mutating and structs get an automatic memberwise initializer; classes use reference semantics and may define deinit.
- Identity & lifecycle: classes have identity (===), are reference-counted, and can define deinitializers; structs have no identity and are compared by value.


3) Does Swift have null references? If so, show an example. If not, how exactly did they prevent this billion dollar mistake?

Swift does not have null refrences. The developers avoided this by creating something called optionals. This is a type that can either hold a value or have no value at all. It allows you to explicitly state uncertainties in the code.

4) Assuming Dog is a subclass of Animal, should you be able to assign an expression of List<Dog> to a variable type constrained as List<Animal> in its declaration? Answer not in terms of what some languages do, but what makes the most sense in terms of type safety.

No, you should not be able to assign a List<Dog> to a variable declared as List<Animal> if you care about type safety. Even though every dog is an animal, a list of dogs is not the same as a list of animals. If you allowed that assignment, someone could later add a different kind of animal, like a cat, to the list and that would break the list’s guarantee that it only contains dogs. Preventing this kind of assignment keeps the type system safe and consistent, ensuring that once a list is declared to hold only dogs, nothing that isn’t a dog can ever end up inside it

5) Why is Swift’s Void type weirdly named? What is their “excuse” for using that term for what is essentially a unit type?

In Swift when we use Void we are actually using a type alias for an empty tuple. It basically means that we are returning a value that has no helpful information in it. they call it this because developers in other languages are used to using void in their other languages. It exists like this for legacy and readability. 

6) What is the type of a supplier in Swift?

In swift a supplier is a function that takes no parameters and returns a value when called. written like () -> T, where T is the type of value that it produces. Essentialy a supplier can be any type determined by the type of the value it is returning.

7) Why did Yegor Bugayenko think Alan Kay was wrong about being wrong about using the term “object” when he coined the term “object-oriented programming”?

Kay regrets the term “object” because it shifted many people’s attention toward what Kay considered the lesser idea (objects themselves) and away from the real idea (messaging and dynamic interactions). However, Bugayenko thinks that the term “object” was appropriate after all because real robust OOP requires more than just messaging — it needs things like composition, structure, and encapsulation that the term “object” better encompasses.

8) What is the difference between class-based and prototype-based OOP?

Class-based and prototype-based object-oriented programming differ primarily in how objects are created and how inheritance is handled. In class-based OOP, objects are instances of classes, which serve as blueprints defining both structure and behavior; inheritance occurs through a class hierarchy where subclasses extend or override parent classes. Languages like Java, C++, and Swift use this model. In contrast, prototype-based OOP has no classes—objects are created by cloning existing objects, called prototypes, and can inherit behavior directly from them. JavaScript and Self exemplify this approach. Prototype-based systems are more flexible at runtime because objects can be modified or extended individually, whereas class-based systems enforce a more rigid structure defined by the class hierarchy. The key distinction is that class-based OOP focuses on types and templates, while prototype-based OOP focuses on individual objects and their relationships.

9) List all the things that a Java record automatically generates.

In java a record is a special class meant to be a concise, immutable data carrier. When you declare a record the java compiler automatically generates 
a) Private final fields for each component declared in the record,
b) A cononical constructor that takes all components as parameters and assigns them to fields
c) A public accessor methods for each component, named exactly as the component
d) An equals method that compares records by value
e) A hashcode method consistent with the equals method
f) And a toString method that returns a string including the record name and all component names  and values

10) Java does not (yet?) have companion objects like Kotlin. What do Java programmers have to use instead?

In java instead of using companion objects we would use static methods and fields. java has kept it this way for sometime now because its simpler and works fine as a work around when companion objects are needed.