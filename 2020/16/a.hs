type Ticket = [Integer]
type Constraint = (String, [(Integer, Integer)])

main :: IO ()
main = interact $ show . solve . input

parseConstraints :: String -> Constraint
parseConstraints s = (str, [(read min1, read max1),(read min2, read max2)])
  where
    (str,':':' ':s') = span (/=':') s
    (min1,'-':s'') = span (/='-') s'
    (max1,' ':'o':'r':' ':s''') = span (/=' ') s''
    (min2,'-':max2) = span (/='-') s'''

parseTicket :: String -> Ticket
parseTicket = map read . words . map (\c->if c==',' then ' ' else c)

input :: String -> (Ticket, [Ticket], [Constraint])
input = go [] . lines
  where
    go cs ("":"your ticket:":ll) = go' cs ll
    go cs (l:ll) = go (parseConstraints l : cs) ll
    go' cs (t:"":"nearby tickets:":ll) = (parseTicket t, go'' ll, cs)
    go'' [] = []
    go'' (l:ll) = parseTicket l : go'' ll

errorRate :: [Constraint] -> Ticket -> Integer
errorRate _ [] = 0
errorRate cs (e:t) | any (\(_,[(mn1,mx1),(mn2,mx2)]) -> mn1 <= e && e <= mx1 || mn2 <= e && e <= mx2) cs = errorRate cs t
                   | otherwise                                                                           = e + errorRate cs t

solve :: (Ticket, [Ticket], [Constraint]) -> Integer
solve (_,ts,cs) = sum $ map (errorRate cs) ts
