main :: IO ()
main = interact $ show . solve . map read . lines

solve :: [Int] -> Int
solve i = let (l,n) = go i $ keys 7 in keys n !! l
  where
    keys n = iterate ((`mod` 20201227) . (*n)) 1
    go ms (n:ns) | n `elem` ms = (0, head (filter (/= n) ms))
                 | otherwise   = let (l',n') = go ms ns in (l'+1,n')
