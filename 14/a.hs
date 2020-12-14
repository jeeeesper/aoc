import Data.Bits
import Data.Map (empty, insert, elems)

data Instruction = Mask [Char] | Mem Int Int

main :: IO ()
main = interact $ show . solve . input

input :: String -> [Instruction]
input = map parseLine . lines
  where
    parseLine ('m':'a':'s':'k':' ':'=':' ':m) = Mask m
    parseLine ('m':'e':'m':'[':l') = Mem (read $ takeWhile (/= ']') l') (read $ words l' !! 2)
    parseLine _ = error "unknown expression"

applyMask :: [Char] -> Int -> Int
applyMask = go 35
  where
    go i ('X':m') v = go (i-1) m' v
    go i ('1':m') v = go (i-1) m' $ setBit v i
    go i ('0':m') v = go (i-1) m' $ clearBit v i
    go _ _ v = v

solve :: [Instruction] -> Int
solve ((Mask mask):xs) = sum . elems $ go empty mask xs
  where
    go mem _ ((Mask m'):is) = go mem m' is
    go mem m ((Mem a v):is) = go (insert a (applyMask m v) mem) m is
    go mem _ _ = mem
solve _ = error "ich raste aus"
