import Data.Array

type Map = Array (Int,Int) Char

main :: IO ()
main = interact $ show . solve . input

input :: String -> Map
input s = listArray ((0,0), (length ll - 1, length l - 1)) $ filter (/='\n') s
  where
    (ll@(l:_)) = lines s

occNeighbors :: (Int,Int) -> Map -> Int
occNeighbors (x,y) a = length $ filter ((==) '#' . (!) a) $ neighbors
  where
    neighbors = concat [go dx dy 1 | dx <- [-1..1], dy <- [-1..1], dx /= 0 || dy /= 0]
    go dx dy k | inRange (bounds a) (x+k*dx, y+k*dy) = if a ! (x+k*dx, y+k*dy) /= '.' then [(x+k*dx, y+k*dy)] else go dx dy (k+1)
               | otherwise = []

nextGen :: Map -> Map
nextGen a = a // [(i,fate i) | i <- indices a]
  where
    fate i | a ! i == 'L' && occNeighbors i a == 0 = '#'
           | a ! i == '#' && occNeighbors i a >= 5 = 'L'
           | otherwise                             = a ! i

solve :: Map -> Int
solve = go
  where
    go m | m == nextGen m = cOcc m
         | otherwise      = go $ nextGen m
    cOcc a = length . filter (=='#') $ elems a
