import Data.List (nub)

main :: IO ()
main = interact $ show . solve . input

parseLine :: String -> [(String, String)]
parseLine l = [(c, bag) | (_,c) <- containing]
  where
    ws = words l
    (bag, _:_:l') = (\(x,y) -> (concat x, y)) $ splitAt 2 ws
    go :: [String] -> [(String, String)]
    containing = go l'
    go [] = []
    go (('n':'o':_):_) = []
    go (n:b:b':_:l'') = (read n, b ++ b') : go l''
    go _ = error "parse error"

input :: String -> [(String, String)]
input = concatMap parseLine . lines

magicBag :: String
magicBag = "shinygold"

closure :: (Eq a) => [a] -> [(a,a)] -> [a]
closure fnd rs | fnd == fnd' = fnd
               | otherwise   = closure fnd' rs
  where
    fnd' = nub $ fnd ++ [ y | (x,y) <- rs, x' <- fnd, x == x']

solve :: [(String, String)] -> Int
solve = flip (-) 1 . length . closure [magicBag]
