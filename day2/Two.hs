module Main where

import Text.Read (readMaybe)
import Data.List (foldl', scanl')

data Action
  = Forward
  | Up
  | Down
  deriving (Show)

data InputError
  = InvalidAction String
  | InvalidNumber String
  deriving (Show, Eq)

parseAction :: String -> Either InputError Action
parseAction input =
  case input of
    "forward" -> Right Forward
    "down" -> Right Down
    "up" -> Right Up
    _ -> Left (InvalidAction input)

parseNumber :: String -> Either InputError Int
parseNumber input = do
  let res = readMaybe input
  case res of
    Just n -> Right n
    Nothing -> Left (InvalidNumber input)


toAction :: [String] -> Either InputError (Action, Int)
toAction (action:number:_) = do
  action <- parseAction action
  number <- parseNumber number
  return (action, number)


accumNavigation :: (Int, Int, Int) -> (Action, Int) -> (Int, Int, Int)
accumNavigation (horiz, depth, aim) (action, n) =
  case action of
    Forward | aim /= 0 -> (horiz + n, depth + (n * aim), aim)
    Forward -> (horiz + n, depth, aim)
    Down -> (horiz, depth, aim + n)
    Up -> (horiz, depth, aim - n)

main :: IO ()
main = do
  result <- (lines <$> getContents) >>= (pure . traverse (toAction . words))
  case result of
    Left err -> putStrLn ("ERROR: " <> show err)
    Right input -> do
      let (horiz, depth, _aim) = foldl' accumNavigation (0, 0, 0) input
      print (horiz * depth)
      -- let result = scanl' accumNavigation (0, 0, 0) input
      -- print result
