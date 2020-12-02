main :: IO ()
main = interact $ show . solve . lines

parse :: String -> (Int, Int, Char, String)
parse str = (read minStr, read maxStr, head ltrStr, pw)
  where
    (minStr, str') = span (/= '-') str
    (maxStr, str'') = span (/= ' ') $ tail str'
    (ltrStr, str''') = span (/= ':') $ tail str''
    pw = tail str'''

ok :: (Int, Int, Char, String) -> Bool
ok (mn,mx,l,pw) = (pw !! mn == l) `xor` (pw !! mx == l)
  where
    xor a b = not a && b || a && not b

solve :: [String] -> Int
solve [] = 0
solve (x:xs) | valid x   = 1 + solve xs
             | otherwise = solve xs
  where
    valid = ok . parse
