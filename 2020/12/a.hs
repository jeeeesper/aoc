main :: IO ()
main = interact $ show . solve . map (\(c:n) -> (c, read n)) . lines

solve :: [(Char, Integer)] -> Integer
solve = md . go 0 0 0
  where
    md (x,y) = abs x + abs y
    go x y d (('N',v):is) = go x (y-v) d is
    go x y d (('S',v):is) = go x (y+v) d is
    go x y d (('E',v):is) = go (x+v) y d is
    go x y d (('W',v):is) = go (x-v) y d is
    go x y d (('L',v):is) = go x y ((d+v) `mod` 360) is
    go x y d (('R',v):is) = go x y ((d-v) `mod` 360) is
    go x y d (('F',v):is) | d == 0 = go x y d $ ('E',v):is
                          | d == 90 = go x y d $ ('N',v):is
                          | d == 180 = go x y d $ ('W',v):is
                          | d == 270 = go x y d $ ('S',v):is
    go x y _ _ = (x,y)
