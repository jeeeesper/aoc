import Data.Bits (clearBit, setBit)
import Data.Map (empty, insert, elems)

data Instruction = Mask [Char] | Mem Int Int

main :: IO ()
main = interact $ show . solve . input

input :: String -> [Instruction]
input = map parseLine . lines
  where
    parseLine ('m':'a':'s':'k':' ':'=':' ':m) = Mask m
    parseLine ('m':'e':'m':'[':l') = Mem (read $ takeWhile (']' /=) l') (read $ words l' !! 2)
    parseLine _ = error "unknown expression"

applyMask :: [Char] -> Int -> [Int]
applyMask = go 35
  where
    go i ('X':m') a = go (i-1) m' (setBit a i) ++ go (i-1) m' (clearBit a i)
    go i ('1':m') a = go (i-1) m' $ setBit a i
    go i ('0':m') a = go (i-1) m' a
    go _ _ a = [a]

solve :: [Instruction] -> Int
solve ((Mask mask):xs) = sum . elems $ go empty mask xs
  where
    go mem _ ((Mask m'):is) = go mem m' is
    go mem m ((Mem a v):is) = go (insertAll (applyMask m a) v mem) m is
    go mem _ _ = mem
    insertAll (a:as) v m = insert a v $ insertAll as v m
    insertAll _ _ m = m
solve _ = error "ich raste aus"
