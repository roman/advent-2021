module Main where

import Data.List (foldl', sort)
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

completeLine chs =
    foldl' step 0 chs
  where
    step acc '(' = (acc * 5) + 1
    step acc '[' = (acc * 5) + 2
    step acc '{' = (acc * 5) + 3
    step acc '<' = (acc * 5) + 4

processLines =
    foldl' step []
  where
    step acc line =
      case processLine line of
        Corrupted _ -> acc
        Valid stack | not (null stack) -> (completeLine stack) : acc

main :: IO ()
main = do
  input <- (lines <$> getContents)
  let scores = processLines input
  print $ head $ drop (length scores `div` 2) (sort scores)
