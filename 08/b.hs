import Data.Array
import Data.Either

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

exec :: Array Int (Bool, Instruction) -> Either String Int
exec = go 0 0
  where
    go a ix arr | ix == snd (bounds arr) + 1 = Right a
                | fst $ arr ! ix = Left "Already visited!"
                | otherwise      = case snd (arr ! ix) of NOP _ -> go a (ix+1) $ markSeen ix arr
                                                          ACC d -> go (a+d) (ix+1) $ markSeen ix arr
                                                          JMP d -> go a (ix+d) $ markSeen ix arr
    markSeen ix arr = accum (\(_,e) _ -> (True, e)) arr [(ix,  undefined)]

fixInstruction :: Int -> Array Int (Bool, Instruction) -> Array Int (Bool, Instruction)
fixInstruction ix arr = let i' = case snd $ arr ! ix of NOP c -> JMP c
                                                        JMP c -> NOP c
                                                        i     -> i
                        in accum (\(s,_) _ -> (s,i')) arr [(ix, undefined)]

solve :: Array Int (Bool, Instruction) -> Int
solve arr = run 0
  where
    run ix = let r = exec $ fixInstruction ix arr
             in if isLeft r then run (ix+1) else fromRight 0 r
