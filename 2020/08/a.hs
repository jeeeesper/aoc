import Data.Array

data Instruction = NOP Int | ACC Int | JMP Int deriving (Show, Eq)

main :: IO ()
main = interact $ show . solve . input

input :: String -> Array Int (Bool, Instruction)
input = (\x -> listArray (0, length x - 1) x) . zip (repeat False) .  map parseInstruction . lines

parseInstruction :: String -> Instruction
parseInstruction i = case ins of "nop" -> NOP val
                                 "acc" -> ACC val
                                 "jmp" -> JMP val
                                 _     -> error "parse error"
  where
    (ins, _:s:val') = break (' ' ==) i
    val | s == '+'  = read val' :: Int
        | otherwise = read (s:val') :: Int

solve :: Array Int (Bool, Instruction) -> Int
solve = go 0 0
  where
    go a i arr | fst $ arr ! i = a
               | otherwise     = case snd (arr ! i) of NOP _ -> go a (i+1) $ markSeen i arr
                                                       ACC d -> go (a+d) (i+1) $ markSeen i arr
                                                       JMP d -> go a (i+d) $ markSeen i arr
    markSeen i arr = accum (\(_,e) _ -> (True, e)) arr [(i,  undefined)]
