import Data.Array

main :: IO ()
main = interact $ show . solve . input

input :: String -> [Int]
input = map read . words . map (\c->if c==',' then ' ' else c)

magicNumber :: Int
magicNumber = 30000000

solve :: [Int] -> Int
solve = go 0 undefined (listArray (0,magicNumber) $ repeat Nothing)
  where
    go i l a [] = iter i l a
    go i _ a (x:xs) = go (i+1) x (a // [(x,Just i)]) xs
    iter i l _ | i == magicNumber = l
    iter i l a = case a!l of Just n  -> let num = i-n-1 in iter (i+1) num $ a // [(l,Just (i-1))]
                             Nothing -> iter (i+1) 0 $ a // [(l,Just (i-1))]
