import Data.List (sort)

main :: IO ()
main = interact $ show . solve (0,0,1) 1 . sort . map read . lines

solve :: (Integer, Integer, Integer) -> Integer -> [Integer] -> Integer
solve (l'',l',l) x xs@(x':xs') | x == x'   = solve (l',l,l+l'+l'') (x+1) xs'
                               | otherwise = solve (l',l,0) (x+1) xs
solve (_,_,l) _ _ = l
