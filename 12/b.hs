main :: IO ()
main = interact $ show . solve . map (\(c:n) -> (c, read n)) . lines

solve :: [(Char, Integer)] -> Integer
solve = md . go 0 0 (10,-1)
  where
    md (x,y) = abs x + abs y
    go x y (dx,dy) (('N',v):is) = go x y (dx,dy-v) is
    go x y (dx,dy) (('S',v):is) = go x y (dx,dy+v) is
    go x y (dx,dy) (('E',v):is) = go x y (dx+v,dy) is
    go x y (dx,dy) (('W',v):is) = go x y (dx-v,dy) is
    go x y w@(dx,dy) (('L',v):is) | v > 0 = go x y (dy,-dx) $ ('L', v-90):is
                                  | otherwise = go x y w is
    go x y w@(dx,dy) (('R',v):is) | v > 0 = go x y (-dy,dx) $ ('R', v-90):is
                                  | otherwise = go x y w is
    go x y w@(dx,dy) (('F',v):is) = go (x+v*dx) (y+v*dy) w is
    go x y _ _ = (x,y)
