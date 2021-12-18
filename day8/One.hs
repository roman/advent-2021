module Main where

import Data.List (foldl', span)
import Control.Arrow (second)
import Control.Monad (foldM)

main :: IO ()
main = do
  ls <- lines <$> getContents
  let accFn acc l = do
      let (digits, output) = second tail $ span (/= "|") $ words l
      let result = foldl' (\acc sym -> case length sym of
                               -- matches 1
                               2 -> acc + 1
                               -- matches 7
                               3  -> acc + 1
                               -- matches 4
                               4 -> acc + 1
                               -- matches 8
                               7 -> acc + 1
                               -- otherwise, ignore
                               _ -> acc) acc output
      return result
  foldM accFn 0 ls >>= print
