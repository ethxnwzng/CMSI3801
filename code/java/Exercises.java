import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {
    
    /**
     * Find the first element in a list that satisfies a predicate and return it lowercased.
     * Returns an Optional containing the lowercased result if found, otherwise Optional.empty().
     * 
     * This demonstrates parametric polymorphism through Java generics.
     */
    public static Optional<String> firstThenLowerCase(
            List<String> list,
            Predicate<String> predicate) {
        return list.stream()
                .filter(predicate)
                .findFirst()
                .map(String::toLowerCase);
    }
    
    /**
     * Chainable sentence builder that joins arguments from successive calls.
     * Exposes an 'and' method for adding words and a 'phrase' property for getting the result.
     */
    // Start a fresh, empty builder to accumulate words.
    public static SayBuilder say() {
        return new SayBuilder(new ArrayList<>());
    }
    
    // Convenience overload that seeds the builder with the first word.
    public static SayBuilder say(String word) {
        SayBuilder builder = new SayBuilder(new ArrayList<>());
        return builder.and(word);
    }
    
    // Immutable, chainable helper that captures the current phrase state.
    static class SayBuilder {
        private final List<String> words;
        
        SayBuilder(List<String> words) {
            this.words = new ArrayList<>(words);
        }
        
        // Return a brand-new builder with the additional word appended.
        SayBuilder and(String word) {
            SayBuilder newBuilder = new SayBuilder(words);
            newBuilder.words.add(word);
            return newBuilder;
        }
        
        // Materialise the accumulated words into a single sentence.
        String phrase() {
            return String.join(" ", words);
        }
    }
    
    /**
     * Count lines in a file that are not empty, not entirely whitespace,
     * and don't start with # after whitespace.
     * Uses BufferedReader with try-with-resources and lines() stream method.
     */
    static long meaningfulLineCount(String filename) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            return reader.lines()
                    .filter(line -> {
                        String trimmed = line.trim();
                        return !trimmed.isEmpty() && !trimmed.startsWith("#");
                    })
                    .count();
        }
        //no need to close reader here because it's closed in the try-with-resources block
    }
    
}

/**
 * Immutable quaternion datatype using Java record.
 * Supports addition, multiplication, conjugate, and string representation.
 */
record Quaternion(double a, double b, double c, double d) {
    // Record fields are automatically final and immutable
    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);
    
    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }
    
    public Quaternion plus(Quaternion q) {
        return new Quaternion(a + q.a, b + q.b, c + q.c, d + q.d);
    }
    
    public Quaternion times(Quaternion q) {
        return new Quaternion(
            a * q.a - b * q.b - c * q.c - d * q.d,
            a * q.b + b * q.a + c * q.d - d * q.c,
            a * q.c - b * q.d + c * q.a + d * q.b,
            a * q.d + b * q.c - c * q.b + d * q.a
        );
    }
    
    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }
    
    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }
    
    @Override
    public String toString() {
        if (a == 0 && b == 0 && c == 0 && d == 0) return "0";
        
        StringBuilder sb = new StringBuilder();
        
        if (a != 0) {
            sb.append(formatNumber(a));
        }
        
        if (b != 0) {
            sb.append(formatTerm(b, "i"));
        }
        
        if (c != 0) {
            sb.append(formatTerm(c, "j"));
        }
        
        if (d != 0) {
            sb.append(formatTerm(d, "k"));
        }
        
        String result = sb.toString();
        if (result.startsWith("+")) {
            result = result.substring(1);
        }
        return result;
    }
    
    private String formatTerm(double val, String unit) {
        String sign = val < 0 ? "-" : "+";
        double absVal = Math.abs(val);
        if (absVal == 1) {
            return sign + unit;
        } else {
            return sign + formatNumber(absVal) + unit;
        }
    }
    
    private String formatNumber(double n) {
        if (n == (long) n) {
            return String.format("%.1f", n);
        }
        return String.valueOf(n);
    }
}

/**
 * Generic, persistent binary search tree of strings.
 * This sealed interface is the root of the hierarchy—only {@code Empty} and {@code Node}
 * are allowed to implement it, which keeps the tree representation well-defined.
 */
sealed interface BinarySearchTree permits Empty, Node {
    int size();
    boolean contains(String x);
    BinarySearchTree insert(String x);
}

/**
 * Leaf implementation that represents the absence of a value.
 * Acts as the structural base case from which every real tree grows.
 */
final class Empty implements BinarySearchTree {
    @Override
    public int size() {
        return 0;
    }
    
    @Override
    public boolean contains(String x) {
        return false;
    }
    
    @Override
    public BinarySearchTree insert(String x) {
        // Inserting into an empty tree creates the first Node and two empty children.
        return new Node(x, new Empty(), new Empty());
    }
    
    @Override
    public String toString() {
        return "()";
    }
}

/**
 * Internal tree node: carries a value plus references to left and right subtrees.
 * Recursively composed of more {@code Node} or {@code Empty} instances to describe the tree.
 */
final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;
    
    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }
    
    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }
    
    @Override
    public boolean contains(String x) {
        int cmp = x.compareTo(value);
        if (cmp == 0) return true;
        if (cmp < 0) return left.contains(x);
        return right.contains(x);
    }
    
    @Override
    public BinarySearchTree insert(String x) {
        int cmp = x.compareTo(value);
        if (cmp == 0) return this; // No duplicates
        if (cmp < 0) return new Node(value, left.insert(x), right);
        return new Node(value, left, right.insert(x));
    }
    
    @Override
    public String toString() {
        String leftStr = left instanceof Empty ? "" : left.toString();
        String rightStr = right instanceof Empty ? "" : right.toString();
        return "(" + leftStr + value + rightStr + ")";
    }
}

