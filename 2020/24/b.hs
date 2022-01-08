import Data.Set (Set)
import qualified Data.Set as S
import Text.ParserCombinators.ReadP

main :: IO ()
main = interact $ show . solve . map (coord (0,0)) . fst . last . readP_to_S parser

parser :: ReadP [[String]]
parser = sepBy1 line $ char '\n'

line :: ReadP [String]
line = many1 $ string "e" +++ string "se" +++ string "sw" +++ string "w" +++ string "nw" +++ string "ne"

coord :: (Int,Int) -> [String] -> (Int,Int)
coord (q,r) ("e":xs)  = coord (q+1,r) xs
coord (q,r) ("se":xs) = coord (q,r+1) xs
coord (q,r) ("sw":xs) = coord (q-1,r+1) xs
coord (q,r) ("w":xs)  = coord (q-1,r) xs
coord (q,r) ("nw":xs) = coord (q,r-1) xs
coord (q,r) ("ne":xs) = coord (q+1,r-1) xs
coord c _ = c

step :: Set (Int,Int) -> Set (Int,Int)
step s = S.filter fate $ foldr (\c s' -> S.union s' $ neighbours c) S.empty s
  where
    neighbours (q,r) = S.fromList [(q+1,r),(q,r+1),(q-1,r+1),(q-1,r),(q,r-1),(q+1,r-1)]
    blackNeighbours = S.intersection s . neighbours
    fate c | S.member c s = let l = length (blackNeighbours c) in not (l == 0 || l > 2)
           | otherwise    = length (blackNeighbours c) == 2

solve :: [(Int,Int)] -> Int
solve = S.size . (!! 100) . iterate step . go S.empty
  where
    go s [] = s
    go s (c:cs) | S.member c s = go (S.delete c s) cs
                | otherwise    = go (S.insert c s) cs
