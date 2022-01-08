import qualified Data.Map as M
import Data.Char (isDigit)
import Data.List (transpose, find)
import Data.Maybe (isJust)
import Text.ParserCombinators.ReadP

data Transform = Rot Int | FlipHoriz | FlipVert | Diag1 | Diag2 deriving (Show, Eq)
data Neighbours = Neighbours { left :: Neighbour
                             , right :: Neighbour
                             , top :: Neighbour
                             , bottom :: Neighbour } deriving (Show, Eq)
type Neighbour = Maybe (Int, Transform)
type Tile = (Int, Frame)
type Frame = [[Bool]]

main :: IO ()
main = interact $ show . solve . M.fromList . fst . last . readP_to_S (sepBy1 tile $ string "\n\n")

tile :: ReadP Tile
tile = do
  _ <- string "Tile "
  n <- read <$> munch1 isDigit
  _ <- string ":\n"
  m <- sepBy1 (map (=='#') <$> many1 (char '.' +++ char '#')) $ char '\n'
  return (n, m)

solve :: M.Map Int Frame -> Int
solve ts = product . M.keys . M.filter ((==2) . neighbourCount) $ M.mapWithKey (\n _ -> matchEdges ts n) ts
  where
    neighbourCount Neighbours {left=l,right=r,top=t,bottom=b} = length $ filter isJust [l,r,t,b]

matchEdges :: M.Map Int Frame -> Int -> Neighbours
matchEdges ts n = Neighbours { left = match (Rot 180), right = match (Rot 0), top = match (Rot 270), bottom = match (Rot 90) }
  where
    match rot = M.lookupGT (-1) . M.mapMaybe (matchFrameRight $ transform rot (ts M.! n)) $ M.delete n ts

matchFrameRight, matchFrameBottom :: Frame -> Frame -> Maybe Transform
matchFrameRight = matchFrame mRight
  where mRight f = (==(last $ transpose f)) . (head . transpose)
matchFrameBottom = matchFrame mBottom
  where mBottom f = (== last f) . head

matchFrame :: (Frame -> Frame -> Bool) -> Frame -> Frame -> Maybe Transform
matchFrame fn f f' = case find (fn f . snd) $ allTrans f' of
                      Just (t,_) -> Just t
                      _          -> Nothing

allTrans :: Frame -> [(Transform, Frame)]
allTrans f = zip possible $ map (`transform` f) possible
  where
    possible = [Rot 0, Rot 90, Rot 180, Rot 270, FlipHoriz, FlipVert, Diag1, Diag2]

transform :: Transform -> Frame -> Frame
transform (Rot 0) = id
transform (Rot 90) = transform FlipVert . transform Diag1
transform (Rot 180) = transform FlipHoriz . transform FlipVert
transform (Rot 270) = transform FlipHoriz . transform Diag1
transform FlipHoriz = map reverse
transform FlipVert = reverse
transform Diag1 = transpose
transform Diag2 = transform (Rot 90) . transform FlipVert
transform _ = error "unknown transform"
