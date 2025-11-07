import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

// 1. firstThenLowerCase - returns the first element satisfying the predicate, lowercased, or null
// Generic function with type constraint: T must be a CharSequence (String, StringBuilder, etc.)
// The 'where' clause restricts the generic type parameter
fun <T> firstThenLowerCase(list: List<T>, predicate: (T) -> Boolean): String? 
    where T : CharSequence {
    // firstOrNull returns null if no match found (safer than first which throws)
    // ?. is the safe call operator - only calls lowercase() if firstOrNull didn't return null
    // This chain returns null if list is empty or no element matches predicate
    return list.firstOrNull(predicate)?.toString()?.lowercase()
}

// 2. say - builder pattern for joining words
// The Say class maintains an immutable list of words and provides a phrase property
// that joins them with single spaces, preserving empty strings for spacing.
class Say(private val words: List<String> = emptyList()) {
    // Custom property getter - computed property that runs this code when accessed
    // 'when' is Kotlin's enhanced switch/if-else expression (returns a value)
    val phrase: String
        get() = when {
            words.isEmpty() -> ""
            words.size == 1 -> words[0]
            else -> {
                // Manually join words with spaces to preserve empty strings correctly
                // Empty strings in the list still contribute to spacing
                val result = StringBuilder()
                // words.indices gives IntRange of valid indices (0..words.size-1)
                for (i in words.indices) {
                    if (i > 0) result.append(" ")
                    result.append(words[i])
                }
                result.toString()
            }
        }
    
    fun and(word: String): Say {
        // List + element creates a new list (immutability)
        // Return a new Say instance with the word appended (immutable pattern)
        return Say(words + word)
    }
}

// Two separate say functions as required (function overloading):
// 1. say() with no parameters - creates an empty Say builder
fun say(): Say {
    return Say()
}

// 2. say(word) with a word parameter - creates a Say builder with the initial word
// listOf() is a standard library function to create immutable lists
fun say(word: String): Say {
    return Say(listOf(word))
}

// 3. meaningfulLineCount - counts non-empty, non-whitespace, non-comment lines
// Returns Long (64-bit integer) as required by the test
fun meaningfulLineCount(filename: String): Long {
    // .use() is Kotlin's try-with-resources equivalent - automatically closes the resource
    // Lambda parameter 'reader' is inferred from context
    BufferedReader(FileReader(filename)).use { reader ->
        // reader.lines() returns a Stream<String> (Java 8+)
        // filter() takes a lambda predicate - only keeps lines that return true
        return reader.lines()
            .filter { line ->
                val trimmed = line.trim()
                // isNotEmpty() is extension function (more readable than length > 0)
                trimmed.isNotEmpty() && !trimmed.startsWith("#")
            }
            .count() // Returns Long
    }
}

// 4. Quaternion - immutable data class for quaternions
// 'data class' automatically generates equals(), hashCode(), toString(), copy(), and component functions
// All properties are 'val' (immutable) - cannot be reassigned after construction
data class Quaternion(
    val a: Double,
    val b: Double,
    val c: Double,
    val d: Double
) {
    // companion object = static members in Java (accessed via Quaternion.ZERO, not instance)
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
    
    // Single-expression function syntax - no braces needed when body is a single expression
    fun coefficients(): List<Double> = listOf(a, b, c, d)
    
    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)
    
    // operator keyword allows using + and * as operators (q1 + q2 instead of q1.plus(q2))
    // This is operator overloading - enables natural mathematical syntax
    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(
            a + other.a,
            b + other.b,
            c + other.c,
            d + other.d
        )
    }
    
    operator fun times(other: Quaternion): Quaternion {
        // Quaternion multiplication formula (Hamilton product)
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }
    
    override fun toString(): String {
        val parts = mutableListOf<String>()
        
        if (a != 0.0) {
            parts.add(formatCoefficient(a))
        }
        
        if (b != 0.0) {
            parts.add(formatImaginary(b, "i"))
        }
        
        if (c != 0.0) {
            parts.add(formatImaginary(c, "j"))
        }
        
        if (d != 0.0) {
            parts.add(formatImaginary(d, "k"))
        }
        
        if (parts.isEmpty()) {
            return "0"
        }
        
        // joinToString with lambda transform - "" means no separator between parts
        // String template: $part inserts the variable value into the string
        return parts.joinToString("") { part ->
            if (part.startsWith("-")) part else if (parts.indexOf(part) == 0) part else "+$part"
        }
    }
    
    private fun formatCoefficient(value: Double): String {
        return if (value == 0.0) {
            "0"
        } else if (value == value.toInt().toDouble()) {
            // For whole numbers, show with .0 (e.g., 1.0 not 1)
            // String template with expression: ${expression} evaluates the expression
            "${value.toInt()}.0"
        } else {
            // String template: $value automatically calls toString()
            "$value"
        }
    }
    
    private fun formatImaginary(value: Double, unit: String): String {
        // 'when' as expression - each branch returns a value
        // No argument to 'when' means it's like a series of if-else conditions
        return when {
            value == 1.0 -> unit
            value == -1.0 -> "-$unit"
            value == value.toInt().toDouble() -> "${value.toInt()}.0$unit"
            else -> "$value$unit"
        }
    }
}

// 5. BinarySearchTree - sealed interface with nested implementations
// 'sealed' restricts inheritance - only classes in this file can implement it
// This enables exhaustive 'when' expressions (compiler knows all possible types)
sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree
    
    // 'object' = singleton instance (like static final in Java)
    // Only one Empty instance exists, accessed as BinarySearchTree.Empty
    object Empty : BinarySearchTree {
        override fun size(): Int = 0
        override fun contains(value: String): Boolean = false
        override fun insert(value: String): BinarySearchTree = Node(value, Empty, Empty)
        override fun toString(): String = "()"
    }
    
    // 'data class' nested inside sealed interface - gets all data class benefits
    // Immutable by default (all properties are 'val')
    data class Node(
        val value: String,
        val left: BinarySearchTree,
        val right: BinarySearchTree
    ) : BinarySearchTree {
        override fun size(): Int = 1 + left.size() + right.size()
        
        override fun contains(value: String): Boolean {
            // 'when' expression - each branch returns a Boolean
            // String comparison uses compareTo() under the hood (< and > operators)
            return when {
                value == this.value -> true
                value < this.value -> left.contains(value)
                else -> right.contains(value)
            }
        }
        
        override fun insert(value: String): BinarySearchTree {
            // Persistent data structure - returns new tree instead of modifying existing
            // Immutability: original tree unchanged, new tree shares unchanged subtrees
            return when {
                value < this.value -> Node(this.value, left.insert(value), right)
                value > this.value -> Node(this.value, left, right.insert(value))
                else -> this // value already exists, return unchanged tree
            }
        }
        
        override fun toString(): String {
            // Smart cast: after 'is Empty' check, compiler knows 'left' is Empty type
            // Can use Empty-specific members without explicit cast
            val leftStr = if (left is Empty) "" else left.toString()
            val rightStr = if (right is Empty) "" else right.toString()
            // String interpolation: variables inserted directly into string
            return "($leftStr$value$rightStr)"
        }
    }
}

