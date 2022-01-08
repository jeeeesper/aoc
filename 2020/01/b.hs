main :: IO ()
main = interact $ show . solve . map read . lines

solve :: [Integer] -> Integer
solve xs = head [a*b*c | a <- xs, b <- xs, c <- xs, a+b+c == 2020]
