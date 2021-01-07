import Data.List (inits, tails)

main :: IO ()
main = interact $ show . solve . reverse . map read . lines

preamble :: Int
preamble = 25

solve :: [Integer] -> Integer
solve xs = minimum ns + maximum ns
  where
    ns = head . filter ((==) n . sum) . concatMap tails $ inits ns'
    (n:ns') = solve' xs
    solve' [] = error "fookin laser soights"
    solve' ys@(y:ys') | null [a+b | a <- take preamble ys', b <- take preamble ys', a+b==y] = ys
                      | otherwise = solve' ys'
