main :: IO ()
main = interact $ show . solve . input

input :: String -> (Integer, [Integer])
input s = (read a, parse ds)
  where
    (a:ds:_) = lines s
    parse = map read . filter (/="x") . words . map (\c -> if c==',' then ' ' else c)

solve :: (Integer, [Integer]) -> Integer
solve (a,ds) = wait * bus
  where
    (wait, bus) = minimum [((b-mod a b),b) | b <- ds ]
