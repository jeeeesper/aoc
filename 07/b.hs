main :: IO ()
main = interact $ show . solve . input

parseLine :: String -> [(String, String, Integer)]
parseLine l = [(bag, c, n) | (n,c) <- containing]
  where
    ws = words l
    (bag, _:_:l') = (\(x,y) -> (concat x, y)) $ splitAt 2 ws
    go :: [String] -> [(Integer, String)]
    containing = go l'
    go [] = []
    go (('n':'o':_):_) = []
    go (n:b:b':_:l'') = (read n, b ++ b') : go l''
    go _ = error "parse error"

input :: String -> [(String, String, Integer)]
input = concatMap parseLine . lines

magicBag :: String
magicBag = "shinygold"

closure :: (Eq a) => [(a, Integer)] -> [(a, Integer)] -> [(a,a, Integer)] -> [(a, Integer)]
closure fnd work rs | fnd == fnd' = fnd
                    | otherwise   = closure fnd' work' rs
  where
    work' = [ (y,n*n') | (x, n) <- work, (x',y,n') <- rs, x == x' ]
    fnd'  = work ++ fnd

solve :: [(String, String, Integer)] -> Integer
solve = subtract 1 . sum . map snd . closure [] [(magicBag, 1)]
