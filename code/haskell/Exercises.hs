{-# LANGUAGE DeriveFunctor #-}

{- We have to declare our module Exercises here so they can be explicily exported to other modules.
in our case we're exporting to the test file. we have different types -}

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

import Data.List (find)
import Data.Char (isSpace)

-- 1) firstThenApply: use fmap / <$> and Data.List.find
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = f <$> find p xs

-- 2) infinite sequence of powers of base
-- Restrict base to Integral; use a section (*b) as hinted.
powersOf :: (Integral a) => a -> [a]
powersOf b = iterate (* b) 1
-- Alias used by tests
powers :: (Integral a) => a -> [a]
powers = powersOf

-- 3) count non-empty, non-whitespace-only, non-# comment lines
-- Use readFile which auto-closes; propagate exceptions (no catching).
countCodeLines :: FilePath -> IO Int
countCodeLines path = do
  content <- readFile path
  let ls = lines content
      isCodeLine s =
        case dropWhile isSpace s of
          ""    -> False
          (c:_) -> c /= '#'
  return $ length (filter isCodeLine ls)
-- Alias expected by tests
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount = countCodeLines

-- 4) Shapes: algebraic data types; value-based equality; immutable by default
data Shape
  = Box { width :: !Double, height :: !Double, depth :: !Double }
  | Sphere { radius :: !Double }
  deriving (Eq)

surfaceArea :: Shape -> Double
surfaceArea (Box w h d) = 2 * (w*h + w*d + h*d)
surfaceArea (Sphere r)  = 4 * pi * r * r

volume :: Shape -> Double
volume (Box w h d) = w * h * d
volume (Sphere r)  = (4/3) * pi * r^3

-- 5) Generic, persistent binary search tree (abstract type exported without constructors)
-- The BST type is generic over elements of any Ord type.
data BST a = Empty | Node a (BST a) (BST a)
  deriving (Functor, Eq)

-- Do not export the constructors Empty or Node: BST is abstract to callers of this module.
-- (We export them above because the test suite expects to construct Empty directly.)

emptyBST :: BST a
emptyBST = Empty

insertBST :: (Ord a) => a -> BST a -> BST a
insertBST x Empty = Node x Empty Empty
insertBST x (Node y l r)
  | x == y    = Node y l r          -- no duplicates; preserve original node
  | x < y     = Node y (insertBST x l) r
  | otherwise = Node y l (insertBST x r)

-- alias expected by tests
insert :: (Ord a) => a -> BST a -> BST a
insert = insertBST

lookupBST :: (Ord a) => a -> BST a -> Bool
lookupBST _ Empty = False
lookupBST x (Node y l r)
  | x == y    = True
  | x < y     = lookupBST x l
  | otherwise = lookupBST x r

-- alias expected by tests
contains :: (Ord a) => a -> BST a -> Bool
contains = lookupBST

countBST :: BST a -> Int
countBST Empty = 0
countBST (Node _ l r) = 1 + countBST l + countBST r

-- alias expected by tests
size :: BST a -> Int
size = countBST

inorderBST :: BST a -> [a]
inorderBST Empty = []
inorderBST (Node x l r) = inorderBST l ++ (x : inorderBST r)

-- alias expected by tests
inorder :: BST a -> [a]
inorder = inorderBST

-- string description of the tree expected by tests:
-- Empty -> "()"
-- Node: "(" ++ left ++ show x ++ right ++ ")"
-- where left/right omitted when Empty
showBST :: (Show a) => BST a -> String
showBST = go
  where
    go Empty = "()"
    go (Node x l r) =
      let ls = case l of { Empty -> ""; _ -> go l }
          rs = case r of { Empty -> ""; _ -> go r }
      in "(" ++ ls ++ show x ++ rs ++ ")"

-- provide a Show instance so 'show' behaves as tests expect
instance (Show a) => Show (BST a) where
  show = showBST

instance Show Shape where
  show (Sphere r)  = "Sphere " ++ show r
  show (Box w h d) = "Box " ++ show w ++ " " ++ show h ++ " " ++ show d
