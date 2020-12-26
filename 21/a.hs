import Data.Map (Map)
import qualified Data.Map as M
import Data.List (delete, intersect, (\\))

main :: IO ()
main = interact $ show . solve . input

input :: String -> [([String], [String])]
input = map parseLine . lines
  where
    parseLine s = let (ingS,allS) = break (=='(') s
                    in (words ingS, (drop 1 . map init . words) allS)

toMap :: [([String], [String])] -> Map String [String]
toMap = foldr (\(is,as) -> flip (foldr (flip (M.insertWith intersect) is)) as) M.empty

assign :: Map String [String] -> [(String, String)]
assign m = case M.lookupMin (M.filter ((==) 1 . length) m) of
             Just (a,i:_) -> (a,i) : assign (M.map (delete i) $ M.delete a m)
             _            -> []

solve :: [([String], [String])] -> Int
solve i = diff i $ (assign . toMap) i
  where
    diff x y = (\s -> sum $ map (length . (\\ s) . fst) x) $ map snd y
