module Main where

import qualified Data.List as List
import qualified Data.Set as Set
import qualified Data.Map as Map
import Data.List (foldl', span)
import Control.Arrow (second)
import Control.Monad (foldM)

processInput (db, other@(fives, sixes)) sym0 =
  let
    sym = Set.fromList sym0
  in
    case length sym0 of
      -- matches 1
      2 -> (Map.insert 1 sym db, other)
      -- matches 7
      3  -> (Map.insert 7 sym db, other)
      -- matches 4
      4 -> (Map.insert 4 sym db, other)
      -- matches 8
      7 -> (Map.insert 8 sym db, other)
      -- otherwise, ignore
      5 -> (db, (sym:fives, sixes))
      6 -> (db, (fives, sym:sixes))


insert0 sixDigits db =
    case List.partition (one `Set.isSubsetOf`) sixDigits of
      ([zero], rem) -> (rem, Map.insert 0 zero db)
      _ -> (sixDigits, db)
  where
    Just one = Map.lookup 1 db

insert9 sixDigits db =
    case List.partition (four `Set.isSubsetOf`) sixDigits of
      ([nine], rem) -> (rem, Map.insert 9 nine db)
      _ -> (sixDigits, db)
  where
    Just four = Map.lookup 4 db

insert3 fiveDigits db =
    case List.partition (one `Set.isSubsetOf`) fiveDigits of
      ([three], rem) -> (rem, Map.insert 3 three db)
      _ -> (fiveDigits, db)
  where
    Just one = Map.lookup 1 db

insert5 fiveDigits db =
    case List.partition (`Set.isSubsetOf` six) fiveDigits of
      ([five], rem) -> (rem, Map.insert 5 five db)
      _ -> (fiveDigits, db)
  where
    Just six = Map.lookup 6 db

reverseMap db =
  Map.foldrWithKey (\k v -> Map.insert v k) Map.empty db


main :: IO ()
main = do
  ls <- lines <$> getContents
  let accFn acc l = do
      let (digits, output) = second (reverse . map Set.fromList . tail) $ span (/= "|") $ words l
      let (db0, (fives0, sixes0)) = foldl' processInput (Map.empty, ([], [])) digits
      let (sixes1, db1) = insert9 sixes0 db0
      let ([six], db2) = insert0 sixes1 db1
      let db3 = Map.insert 6 six db2
      let (fives1, db4) = insert3 fives0 db3
      let ([two], db5) = insert5 fives1 db4
      let db6 = Map.insert 2 two db5
      let db = reverseMap db6
      let outputNumber = List.foldr (\v acc -> (acc * 10) + (maybe 0 id $ Map.lookup v db)) 0 output
      return $ acc + outputNumber
  foldM accFn 0 ls >>= print
