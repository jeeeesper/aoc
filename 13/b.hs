import Data.Bifunctor (second)

main :: IO ()
main = interact $ show . solve . input

input :: String -> [(Integer, Integer)]
input = map (second read) . filter ((/=) "x" . snd) . zip [0..] . words . map (\c -> if c==',' then ' ' else c) . flip (!!) 1 . lines

solve :: [(Integer,Integer)] -> Integer
solve = go 0 1
  where
    go t lcd xs@((o,b):xs') | mod (t+o) b == 0 = go t (lcd*b) xs'
                            | otherwise        = go (t+lcd) lcd xs
    go t _ _ = t
