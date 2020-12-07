import Data.List (nub)
import Data.Text (splitOn, pack, unpack)

main :: IO ()
main = interact $ show . solve . map unpack . splitOn (pack "\n\n") . pack

solve :: [String] -> Int
solve []     = 0
solve (s:ss) = (length . nub . filter ((/=) '\n')) s + solve ss
