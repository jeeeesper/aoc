import Data.List (nub)
import Data.Text (splitOn, pack, unpack)

main :: IO ()
main = interact $ show . solve . map unpack . splitOn (pack "\n\n") . pack

solve :: [String] -> Int
solve ss = sum $ map (length . nub . filter ((/=) '\n')) ss
