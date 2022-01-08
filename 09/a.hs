main :: IO ()
main = interact $ show . solve . reverse . map read . lines

preamble :: Int
preamble = 25

solve :: [Integer] -> Integer
solve [] = error "mulm"
solve (x:xs) | null [a+b | a <- take preamble xs, b <- take preamble xs, a+b==x] = x
             | otherwise = solve xs
