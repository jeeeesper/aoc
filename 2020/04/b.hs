import Text.Regex.Posix
import Data.List.Split

main :: IO ()
main = interact $ show . solve . splitOn "\n\n"

reqFields :: [String]
reqFields = [ "\\bbyr:(19[2-9][0-9]|200[0-2])\\b"
            , "\\biyr:(20(1[0-9]|20))\\b"
            , "\\beyr:(20(2[0-9]|30))\\b"
            , "\\bhgt:(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)\\b"
            , "\\bhcl:#([0-9a-f]{6})\\b"
            , "\\becl:(amb|blu|brn|gry|grn|hzl|oth)\\b"
            , "\\bpid:([0-9]{9})\\b" ]

solve :: [String] -> Integer
solve [] = 0
solve (pp:pps) | all (pp =~) reqFields = 1 + solve pps
               | otherwise             = solve pps
