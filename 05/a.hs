main :: IO ()
main = interact $ show . solve . map parse . lines

parse :: String -> (Integer, Integer)
parse = go (0,127) (0,7)
  where
    go (minR, _) (minS, _) []  =  (minR, minS)
    go (minR, maxR) s ('F':xs) = go (minR, (minR+maxR) `div` 2) s xs
    go (minR, maxR) s ('B':xs) = go ((minR+maxR) `div` 2 + 1, maxR) s xs
    go r (minS, maxS) ('L':xs) = go r (minS, (minS+maxS) `div` 2) xs
    go r (minS, maxS) ('R':xs) = go r ((minS+maxS) `div` 2 + 1, maxS) xs
    go _ _ _                   = error "Unexpected Input"

solve :: [(Integer, Integer)] -> Integer
solve xs = maximum [ r * 8 + s | (r,s) <- xs ]
