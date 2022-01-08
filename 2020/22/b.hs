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

game :: ([[Int]],[[Int]]) -> ([Int],[Int]) -> (Bool, [Int]) -- Bool iff P1 wins
game _ (as,[]) = (True,as)
game _ ([],bs) = (False,bs)
game (ahs,bhs) (as@(a:ass),bs@(b:bss)) | elem as ahs || elem bs bhs = (True, as)
                                       | a <= length ass && b <= length bss = runSubGame
                                       | a > b = aWins
                                       | otherwise = bWins
  where
    runSubGame | subWinner = aWins
               | otherwise = bWins
    (subWinner, _) = game ([],[]) (take a ass,take b bss)
    aWins = game (as:ahs,bs:bhs) (ass ++ [a,b], bss)
    bWins = game (as:ahs,bs:bhs) (ass, bss ++ [b,a])

solve :: ([Int], [Int]) -> Int
solve = sum . zipWith (*) [1..] . reverse . snd . game ([],[])
