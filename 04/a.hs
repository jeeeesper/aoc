import Text.Regex.Posix
import Data.List.Split

main :: IO ()
main = interact $ show . solve . splitOn "\n\n"

reqFields :: [String]
reqFields = ["byr:", "iyr:", "eyr:", "hgt:", "hcl:", "ecl:", "pid:"]

solve :: [String] -> Integer
solve [] = 0
solve (pp:pps) | all (pp =~) reqFields = 1 + solve pps
               | otherwise             = solve pps
