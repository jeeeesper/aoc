import Data.List (sort)

main :: IO ()
main = interact $ show . solve . sort . map read . lines

solve :: [Integer] -> Integer
solve = go (0,0) . (:) 0
  where
    go _ [] = error "empty input"
    go (o,t) [_] = o * (t+1)
    go (o,t) (x:xs@(x':_)) | x'-x == 1 = go (o+1,t) xs
                           | x'-x == 3 = go (o,t+1) xs
                           | otherwise = error "ich raste aus"
