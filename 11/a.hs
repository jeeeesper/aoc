import Data.Array

type Map = Array (Int,Int) Char

main :: IO ()
main = interact $ show . solve . input

input :: String -> Map
input s = listArray ((0,0), (length ll - 1, length l - 1)) $ filter ('\n' /=) s
  where
    ll@(l:_) = lines s

occNeighbors :: (Int,Int) -> Map -> Int
occNeighbors (x,y) a = length $ filter ((==) '#' . (!) a) neighbors
  where
    neighbors = [(x',y') | (x',y') <- [(x-1, y-1), (x, y-1), (x+1, y-1), (x-1, y), (x+1, y), (x-1, y+1), (x, y+1), (x+1, y+1)], flip inRange (x',y') $ bounds a]

nextGen :: Map -> Map
nextGen a = a // [(i,fate i) | i <- indices a]
  where
    fate i | a ! i == 'L' && occNeighbors i a == 0 = '#'
           | a ! i == '#' && occNeighbors i a >= 4 = 'L'
           | otherwise                             = a ! i

solve :: Map -> Int
solve = go
  where
    go m | m == nextGen m = cOcc m
         | otherwise      = go $ nextGen m
    cOcc a = length . filter ('#' ==) $ elems a
