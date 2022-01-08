import Data.Array (Array, array, bounds, elems, indices, (!), (//))

type Map = Array (Int, Int, Int) Bool

main :: IO ()
main = interact $ show . solve . input

input :: String -> Map
input s = go 0 0 (array ((0,0,0),(length l-1,length ll-1,0)) []) s
  where
    ll@(l:_) = lines s
    go x y a (c:cs) = case c of '.'  -> go (x+1) y (a // [((x,y,0),False)]) cs
                                '#'  -> go (x+1) y (a // [((x,y,0),True)]) cs
                                '\n' -> go 0 (y+1) a cs
                                _    -> error "ich raste aus"
    go _ _ a _ = a

alive :: (Int,Int,Int) -> Map -> Bool
alive i@(x,y,z) m | inBounds i && m ! i = (length . filter id) neighbors `elem` [2,3]
                  | otherwise           = (length . filter id) neighbors == 3
  where
    inBounds (x',y',z') = (\((a,b,c),(d,e,f)) -> a<=x'&&b<=y'&&c<=z'&&d>=x'&&e>=y'&&f>=z') $ bounds m
    neighbors = [ m ! (x',y',z') | x' <- [x-1..x+1], y' <- [y-1..y+1], z' <- [z-1..z+1], x/=x'||y/=y'||z/=z', inBounds (x',y',z') ]

next :: Map -> Map
next m = go $ array ((\((a,b,c),(d,e,f)) -> ((a-1,b-1,c-1),(d+1,e+1,f+1))) $ bounds m) []
  where
    go a = a // [(i, alive i m) | i <- indices a]

solve :: Map -> Int
solve = length . filter id . elems . flip (!!) 6 . iterate next
