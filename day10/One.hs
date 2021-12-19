module Main where

import Data.List (foldl')
import Data.Map (Map)
import qualified Data.Map as Map

data Result
  = Valid [Char]
  | Corrupted Char

processLine =
    foldl' step (Valid [])
  where
    step acc ch =
      case acc of
        Valid [] -> Valid [ch]
        Valid stack@(h:ts) ->
          case ch of
            '(' -> Valid (ch:stack)
            '[' -> Valid (ch:stack)
            '{' -> Valid (ch:stack)
            '<' -> Valid (ch:stack)
            ')' | h == '(' -> Valid ts
            ']' | h == '[' -> Valid ts
            '}' | h == '{' -> Valid ts
            '>' | h == '<' -> Valid ts
            _ -> Corrupted ch
        _ -> acc

processLines =
    foldl' step Map.empty
  where
    step db line =
      case processLine line of
        Corrupted ch -> Map.alter (Just . maybe 1 (+1)) ch db
        _ -> db

chScore ch =
  case ch of
    ')' -> 3
    ']' -> 57
    '}' -> 1197
    '>' -> 25137
    _ -> 0

calcScore ch times total =
  total + (chScore ch * times)


main :: IO ()
main = do
  input <- (lines <$> getContents)
  let db = processLines input
  print db
  print $ Map.foldrWithKey calcScore 0 db
