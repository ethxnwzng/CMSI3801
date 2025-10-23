{-# LANGUAGE DeriveFunctor #-}
module MyLib
  ( -- utilities
    firstThenApply
  , powersOf
  , countCodeLines

    -- shapes
  , Shape(..)
  , surfaceArea
  , volume

    -- persistent BST (type abstract; constructors hidden)
  , BST
  , emptyBST
  , insertBST
  , lookupBST
  , countBST
  , inorderBST
  , showBST
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
-- Note: (* b) is a section;iterate produces [1, b, b^2, b^3, ...] for Integral b

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

-- 4) Shapes: algebraic data types; value-based equality; immutable by default
data Shape
  = Box { width :: !Double, height :: !Double, depth :: !Double }
  | Sphere { radius :: !Double }
  deriving (Eq, Show)

surfaceArea :: Shape -> Double
surfaceArea (Box w h d) = 2 * (w*h + w*d + h*d)
surfaceArea (Sphere r)  = 4 * pi * r * r

volume :: Shape -> Double
volume (Box w h d) = w * h * d
volume (Sphere r)  = (4/3) * pi * r^3

-- 5) Generic, persistent binary search tree (abstract type exported without constructors)
-- The BST type is generic over elements of any Ord type.
data BST a = Empty | Node a (BST a) (BST a)
  deriving (Functor)

-- Do not export the constructors Empty or Node: BST is abstract to callers of this module.

emptyBST :: BST a
emptyBST = Empty

insertBST :: (Ord a) => a -> BST a -> BST a
insertBST x Empty = Node x Empty Empty
insertBST x (Node y l r)
  | x == y    = Node y l r          -- no duplicates; preserve original node
  | x < y     = Node y (insertBST x l) r
  | otherwise = Node y l (insertBST x r)

lookupBST :: (Ord a) => a -> BST a -> Bool
lookupBST _ Empty = False
lookupBST x (Node y l r)
  | x == y    = True
  | x < y     = lookupBST x l
  | otherwise = lookupBST x r

countBST :: BST a -> Int
countBST Empty = 0
countBST (Node _ l r) = 1 + countBST l + countBST r

inorderBST :: BST a -> [a]
inorderBST Empty = []
inorderBST (Node x l r) = inorderBST l ++ (x : inorderBST r)

-- string description of the tree
showBST :: (Show a) => BST a -> String
showBST = go
  where
    go Empty = "Empty"
    go (Node x l r) =
      "Node " ++ show x ++ " (" ++ go l ++ ") (" ++ go r ++ ")"
