import Text.ParserCombinators.ReadP

main :: IO ()
main = interact $ show . sum . map (parseLine . filter (/=' ')) . lines

parseLine :: String -> Int
parseLine = fst . last . readP_to_S expr

expr :: ReadP Int
expr = token `chainl1` (plus +++ times)
  where
    token = between (char '(') (char ')') expr +++ (read <$> munch1 (flip elem ['0'..'9']))
    plus = (+) <$ char '+'
    times = (*) <$ char '*'
