import Data.Set (Set)
import qualified Data.Set as S
import Text.ParserCombinators.ReadP

main :: IO ()
main = interact $ show . solve S.empty . map (coord (0,0)) . fst . last . readP_to_S parser

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

solve :: Set (Int,Int) -> [(Int,Int)] -> Int
solve s [] = S.size s
solve s (c:cs) | S.member c s = solve (S.delete c s) cs
               | otherwise    = solve (S.insert c s) cs
