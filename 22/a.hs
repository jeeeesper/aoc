import Text.ParserCombinators.ReadP
import Data.Char (isDigit)

main :: IO ()
main = interact $ show . solve . fst . head . readP_to_S (parser <* eof)

parser :: ReadP ([Int],[Int])
parser = do
  _ <- string "Player 1:\n"
  as <- sepBy1 (read <$> many1 (satisfy isDigit)) $ char '\n'
  _ <- string "\n\nPlayer 2:\n"
  bs <- sepBy1 (read <$> many1 (satisfy isDigit)) $ char '\n'
  _ <- char '\n'
  return (as,bs)

solve :: ([Int], [Int]) -> Int
solve = sum . zipWith (*) [1..] . reverse . winningHand . head . dropWhile (not . (\(as,bs) -> null as || null bs)) . iterate turn
  where
    turn (a:as,b:bs) | a < b     = (as, bs ++ [b,a])
                     | otherwise = (as ++ [a,b], bs)
    turn _ = error "ich raste aus"
    winningHand ([],bs) = bs
    winningHand (as,[]) = as
    winningHand _       = error "ich raste aus"
