import Foundation
//1
// Returns the lowercased version of the first element in the array that satisfies the predicate
func firstThenLowerCase(of `for`: [String], satisfying predicate: (String) -> Bool) -> String? {
    `for`.first(where: predicate)?.lowercased()
}

//2
struct Phrase {
    let words: [String]
    
    var phrase: String {
        words.joined(separator: " ")
    }

    func and(_ word: String) -> Phrase {
        // Return a new Phrase thats immutable
        // Append new word
        Phrase(words: words + [word])
    }
}

func say(_ word: String = "") -> Phrase {
    Phrase(words: [word])
}

//3

// Asynchronous line counting function
func meaningfulLineCount(_ filename: String) async -> Result<Int, Error> {
    do {
        let fileURL = URL(fileURLWithPath: filename)
        var count = 0
        for try await line in fileURL.lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.isEmpty && !trimmed.starts(with: "#") {
                count += 1
            }
        }
        return .success(count)
    } catch {
        return .failure(error)
    }
}

//4
struct Quaternion: Equatable, CustomStringConvertible {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    // Default initializer
    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    // Coefficients getter
    var coefficients: [Double] { [a, b, c, d] }

    // Conjugate getter
    var conjugate: Quaternion {
        Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    // Static constants getters
    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    // Addition
    static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        Quaternion(a: lhs.a + rhs.a,
                   b: lhs.b + rhs.b,
                   c: lhs.c + rhs.c,
                   d: lhs.d + rhs.d)
    }

    // Multiplication Hamilton product
    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        Quaternion(
            a: lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d,
            b: lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c,
            c: lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b,
            d: lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        )
    }

    // String representation (matches test output formatting)
    var description: String {
        // Build terms only for nonzero coefficients
        func term(_ value: Double, _ symbol: String) -> String {
            guard value != 0 else { return "" }
            var result = ""
            if !symbol.isEmpty {
                // include + or - between terms
                if value > 0 { result += "+" }
                // Special case: for ±1, omit the "1"
                if abs(value - 1.0) < 0.0001 {
                    result += symbol
                } else if abs(value + 1.0) < 0.0001 {
                    result += "-\(symbol)"
                } else {
                    result += "\(value)\(symbol)"
                }
            } else {
                // real term (no symbol)
                result += "\(value)"
            }
            return result
        }

        // Construct each component
        let terms = [
            (a, ""),
            (b, "i"),
            (c, "j"),
            (d, "k")
        ]

        // Combine and clean formatting
        var output = ""
        for (_, (value, symbol)) in terms.enumerated() {
            guard value != 0 else { continue }
            let t = term(value, symbol)
            if output.isEmpty {
                // strip leading "+"
                output += t.hasPrefix("+") ? String(t.dropFirst()) : t
            } else {
                output += t
            }
        }

        // Special case for all-zero quaternion
        if output.isEmpty { output = "0" }

        return output
    }
}

//5
indirect enum BinarySearchTree: CustomStringConvertible {
    case empty
    case node(String, BinarySearchTree, BinarySearchTree)

    // Insert (returns a new tree)
    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(value, .empty, .empty)
        case let .node(v, left, right):
            if value < v {
                return .node(v, left.insert(value), right)
            } else if value > v {
                return .node(v, left, right.insert(value))
            } else {
                return self // ignore duplicates
            }
        }
    }

    // Contains
    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(v, left, right):
            if value == v { return true }
            else if value < v { return left.contains(value) }
            else { return right.contains(value) }
        }
    }

    // Size (computed property)
    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(_, left, right):
            return 1 + left.size + right.size
        }
    }

    // String representation
    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(v, left, right):
            // Format like "((A)B((C)D))G(H(J)))"
            let l: String
            if case .empty = left { l = "" } else { l = "\(left)" }
            let r: String
            if case .empty = right { r = "" } else { r = "\(right)" }
            return "(\(l)\(v)\(r))"
        }
    }
}
