import Text.Regex.Posix
import Data.List.Split

main :: IO ()
main = interact $ show . solve . splitOn "\n\n"

reqFields :: [String]
reqFields = [ "byr:(19[2-9][0-9]|200[0-2])\\b"
            , "iyr:(20(1[0-9]|20))\\b"
            , "eyr:(20(2[0-9]|30))\\b"
            , "hgt:(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)\\b"
            , "hcl:#([0-9a-f]{6})\\b"
            , "ecl:(amb|blu|brn|gry|grn|hzl|oth)\\b"
            , "pid:([0-9]{9})\\b" ]

solve :: [String] -> Integer
solve [] = 0
solve (pp:pps) | and $ map ((=~) pp) reqFields = 1 + solve pps
               | otherwise                     = solve pps
