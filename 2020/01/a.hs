main :: IO ()
main = interact $ show . solve . map read . lines

solve :: [Integer] -> Integer
solve xs = head [a*b | a <- xs, b <- xs, a+b == 2020]
