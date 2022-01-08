import qualified Data.Map as M
import Data.Char (isDigit)
import Data.List (transpose, find, elemIndices, (\\))
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

monster :: [[Bool]]
monster = map (map (=='#')) [ "                  # "
                            , "#    ##    ##    ###"
                            , " #  #  #  #  #  #   " ]

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
solve ts = hashCount assembled - monsterCount * hashCount monster
  where
    hashCount = length . concatMap (filter id)
    monsterCount = sum $ map (findMonsters . snd) (allTrans assembled)
    assembled = assemble ts . map (matchTo matchFrameRight ts . Just) . matchTo matchFrameBottom ts . M.lookupGT (-1) . M.map rotCornerTL . M.filter ((==2) . neighbourCount) $ M.mapWithKey (\t _ -> matchEdges ts t) ts
    neighbourCount Neighbours {left=l,right=r,top=t,bottom=b} = length $ filter isJust [l,r,t,b]

findMonsters :: Frame -> Int
findMonsters f = length . filter includesMonster $ map (imgSlice (length $ head monster, length monster) f) ps
  where
    ps = [ (x,y) | x <- [0..(length . head) f - 1], y <- [0..length f - 1] ]
    imgSlice (w,h) f' (x,y) = map (slice x (x+w)) . slice y (y+h) $ f'
    slice b e = drop b . take e

includesMonster :: Frame -> Bool
includesMonster f = length f == length monster && all null missing
  where
    missing = zipWith (\\) mis fis
    mis = map (elemIndices True) monster
    fis = map (elemIndices True) f

assemble :: M.Map Int Frame -> [[(Int, Transform)]] -> Frame
assemble ts = concatMap (map concat . transpose . map asFrame)
  where
    asFrame (tid, t) = (init . tail) . map (init . tail) $ transform t (ts M.! tid)

rotCornerTL :: Neighbours -> Transform
rotCornerTL Neighbours {left=Nothing,top=Nothing} = Rot 0
rotCornerTL Neighbours {right=Nothing,top=Nothing} = Rot 90
rotCornerTL Neighbours {right=Nothing,bottom=Nothing} = Rot 180
rotCornerTL Neighbours {left=Nothing,bottom=Nothing} = Rot 270
rotCornerTL _ = error "wtf"

matchTo :: (Frame -> Frame -> Maybe Transform) -> M.Map Int Frame -> Maybe (Int, Transform) -> [(Int,Transform)]
matchTo _ _ Nothing = []
matchTo fn ts (Just (tid, rot)) = (tid, rot) : matchTo fn deleted neighbour
  where
    deleted = M.delete tid ts
    neighbour = M.lookupGT (-1) $ M.mapMaybe (fn . transform rot $ ts M.! tid) deleted

matchEdges :: M.Map Int Frame -> Int -> Neighbours
matchEdges ts n = Neighbours { left = match (Rot 180), right = match (Rot 0), top = match (Rot 270), bottom = match (Rot 90) }
  where
    match rot = M.lookupGT (-1) . M.mapMaybe (matchFrameRight $ transform rot (ts M.! n)) $ M.delete n ts

matchFrameRight, matchFrameBottom :: Frame -> Frame -> Maybe Transform
matchFrameRight = matchFrame (\f -> (==(last $ transpose f)) . (head . transpose))
matchFrameBottom = matchFrame (\f -> (== last f) . head)

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
