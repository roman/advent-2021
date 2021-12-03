module Main where

import Text.Read (readMaybe)
import Data.List (foldl')

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


accumNavigation :: (Int, Int) -> (Action, Int) -> (Int, Int)
accumNavigation (horiz, vert) (action, n) =
  case action of
    Forward -> (horiz + n, vert)
    Down -> (horiz, vert + n)
    Up -> (horiz, vert - n)

main :: IO ()
main = do
  result <- (lines <$> getContents) >>= (pure . traverse (toAction . words))
  case result of
    Left err -> putStrLn ("ERROR: " <> show err)
    Right input -> do
      let (horiz, vert) = foldl' accumNavigation (0, 0) input
      print (horiz * vert)
