{-# LANGUAGE DeriveFunctor #-}

{-|
Module      : Exercises
Description : Small exercises demonstrating common Haskell features

This file contains several small utilities used by the test-suite:
  * utilities: higher-order functions and lazy infinite sequences
  * shapes: algebraic data types, pattern matching, and numeric functions
  * BST: a persistent (immutable) binary search tree implementation

The comments below are intentionally pedagogical: they explain both what the
code does and which Haskell language features it is demonstrating.
-}

module Exercises (
    -- utilities
    firstThenApply,
    powersOf,
    powers,                 -- alias expected by tests
    countCodeLines,
    meaningfulLineCount,    -- alias expected by tests

    -- shapes
    Shape(..),
    surfaceArea,
    volume,

    -- persistent BST (export constructors so tests can use Empty)
    BST(..),
    emptyBST,
    insertBST,
    insert,                 -- alias expected by tests
    lookupBST,
    contains,               -- alias expected by tests
    countBST,
    size,                   -- alias expected by tests
    inorderBST,
    inorder,                -- alias expected by tests
    showBST
  ) where

{- IMPORTS
   We import only the small set of functions we need. This emphasizes how Haskell
   modules and selective imports work: you can bring in just the names you use.
-}
import Data.List (find)
import Data.Char (isSpace)

{- Utilities
   1) firstThenApply
      - Types in Haskell are explicit and very helpful for reasoning about code.
      - This function shows higher-order programming: it takes a list, a predicate
        and a transformation function, and returns the transformed first match.
      - Note the use of Maybe to represent a possible missing value (no match).
      - fmap / <$> lifts the function 'f' into the Maybe context so it is only
        applied if 'find' returns a Just value.
-}

-- | Find the first element in a list that satisfies predicate 'p' and apply 'f' to it.
-- Returns 'Nothing' when there is no match.
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = f <$> find p xs
-- Explanation:
--  - 'find p xs' returns 'Maybe a'.
--  - '<$>' applies 'f' to the inside of the Maybe, yielding 'Maybe b'.
-- This composition is concise and avoids explicit case analysis.

{- 2) powersOf
   - Demonstrates laziness and infinite lists. 'iterate' produces an infinite list.
   - Because Haskell is lazy, we can request a finite prefix (e.g., `take 10`) and
     the runtime will compute only as many elements as needed.
   - The type is polymorphic over any Integral base so the same function works for
     Int, Integer, etc.
-}

-- | Infinite list of powers of a base: 1, b, b^2, b^3, ...
powersOf :: (Integral a) => a -> [a]
powersOf b = iterate (* b) 1

-- alias used by the tests
powers :: (Integral a) => a -> [a]
powers = powersOf

{- 3) countCodeLines / meaningfulLineCount
   - Demonstrates IO: reading a file is an effect, so the result lives in the IO monad.
   - Pure vs impure: string processing (lines, dropWhile, isSpace) is pure and done
     after the content is read.
   - We treat lines that are blank or start with '#' (after leading whitespace)
     as non-meaningful (comments). This is intentionally simple.
-}

-- | Count non-empty, non-comment lines in a file.
-- This function performs IO because it uses 'readFile'.
countCodeLines :: FilePath -> IO Int
countCodeLines path = do
  content <- readFile path                -- readFile :: FilePath -> IO String
  let ls = lines content                  -- lines :: String -> [String]
      isCodeLine s =
        case dropWhile isSpace s of       -- drop leading whitespace
          ""    -> False                  -- empty or whitespace-only => not code
          (c:_) -> c /= '#'               -- if first non-space char is '#' it's a comment
  return $ length (filter isCodeLine ls)  -- filter preserves purity; return wraps in IO

-- Alias expected by tests
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount = countCodeLines

{- Shapes: algebraic data types and numeric functions
   - 'Shape' is an algebraic data type (sum type) with two constructors: Box and Sphere.
   - Record syntax (Box { width = ..., ... }) provides named accessors.
   - We derive Eq so values can be compared for equality.
   - Pattern matching is used to define 'surfaceArea' and 'volume'.
   - These functions demonstrate numeric computation and standard library constants (pi).
-}

-- | A simple geometric shape type. The '!' on fields is a strictness annotation;
-- it tells GHC to evaluate those Doubles to WHNF when constructing a Box. This
-- can avoid thunk buildup in some cases but isn't always necessary.
data Shape
  = Box { width :: !Double, height :: !Double, depth :: !Double }
  | Sphere { radius :: !Double }
  deriving (Eq)

-- | Surface area of a shape: pattern matching handles each constructor separately.
surfaceArea :: Shape -> Double
surfaceArea (Box w h d) = 2 * (w*h + w*d + h*d)
surfaceArea (Sphere r)  = 4 * pi * r * r

-- | Volume of a shape.
volume :: Shape -> Double
volume (Box w h d) = w * h * d
volume (Sphere r)  = (4/3) * pi * r^3

{- BST: a persistent binary search tree
   - 'BST a' is defined as a recursive algebraic data type. This demonstrates
     recursion and parametric polymorphism (it works for any 'a').
   - We derive Functor to show how one can map over the structure (mapping the
     stored values). Eq is derived so trees can be compared structurally.
   - All data in Haskell is immutable; 'insert' returns a new tree without
     modifying the old one (this is "persistence").
   - Pattern matching and guards are used in the recursive definitions.
-}

-- | Binary search tree type. 'Empty' is a leaf, 'Node' stores a value and two subtrees.
data BST a = Empty | Node a (BST a) (BST a)
  deriving (Functor, Eq)

-- | A convenience value for an empty tree.
emptyBST :: BST a
emptyBST = Empty

-- | Insert an element into the BST. The tree is persistent (immutable): this returns
-- a new tree; the original tree is preserved.
insertBST :: (Ord a) => a -> BST a -> BST a
insertBST x Empty = Node x Empty Empty
insertBST x (Node y l r)
  | x == y    = Node y l r          -- no duplicates: preserve the node
  | x < y     = Node y (insertBST x l) r  -- insert into left subtree
  | otherwise = Node y l (insertBST x r)  -- insert into right subtree

-- Alias expected by tests
insert :: (Ord a) => a -> BST a -> BST a
insert = insertBST

-- | Lookup: returns True if the value exists in the tree.
lookupBST :: (Ord a) => a -> BST a -> Bool
lookupBST _ Empty = False
lookupBST x (Node y l r)
  | x == y    = True
  | x < y     = lookupBST x l
  | otherwise = lookupBST x r

-- Alias expected by tests
contains :: (Ord a) => a -> BST a -> Bool
contains = lookupBST

-- | Count number of nodes in the tree. This demonstrates a simple structural recursion.
countBST :: BST a -> Int
countBST Empty = 0
countBST (Node _ l r) = 1 + countBST l + countBST r

-- Alias expected by tests
size :: BST a -> Int
size = countBST

-- | Inorder traversal: produces a sorted list when used on a BST of ordered elements.
-- This demonstrates how recursive tree algorithms translate to concise Haskell code.
inorderBST :: BST a -> [a]
inorderBST Empty = []
inorderBST (Node x l r) = inorderBST l ++ (x : inorderBST r)

-- Alias expected by tests
inorder :: BST a -> [a]
inorder = inorderBST

{- showBST and Show instance
   - We build a custom textual representation that the tests expect.
   - The Show instance uses that helper function so 'show tree' prints as desired.
   - This is an example of providing ad-hoc polymorphism in Haskell via typeclasses:
     'Show' is a typeclass and we implement its methods (here, 'show') for our type.
-}

-- | Produce the textual representation used in the tests:
--   Empty -> "()"
--   Node: "(" ++ left ++ show x ++ right ++ ")"
-- where left/right are omitted when Empty so output is compact.
showBST :: (Show a) => BST a -> String
showBST = go
  where
    go Empty = "()"
    go (Node x l r) =
      let ls = case l of { Empty -> ""; _ -> go l }
          rs = case r of { Empty -> ""; _ -> go r }
      in "(" ++ ls ++ show x ++ rs ++ ")"

-- | Implement the standard 'Show' typeclass using our 'showBST' function.
-- This allows 'show tree' to work naturally and integrates with the rest of the
-- Prelude functions that rely on Show (e.g., printing).
instance (Show a) => Show (BST a) where
  show = showBST

{- Custom Show instance for Shape
   - The derived 'Show' format may differ between GHC versions or be more verbose;
     here we provide a stable representation that matches the test expectations.
   - This is a simple example of overriding a derived instance to control textual output.
-}
instance Show Shape where
  show (Sphere r)  = "Sphere " ++ show r
  show (Box w h d) = "Box " ++ show w ++ " " ++ show h ++ " " ++ show d
