import Data.List (intersect, nub)
import Data.Text (splitOn, pack, unpack)

main :: IO ()
main = interact $ show . solve . map unpack . splitOn (pack "\n\n") . pack

solve :: [String] -> Int
solve = sum . map (length . nub . foldr intersect ['a'..'z'] . lines)
