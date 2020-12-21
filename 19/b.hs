import Data.Map (Map, empty, insert, union, fromList, (!))
import Text.ParserCombinators.ReadP
import Data.Char (isDigit)

data RHS = Terminal Char | NonTerminal String | Sequence [RHS] | Choice [RHS] deriving (Show, Eq)
type CFG = Map String RHS

updateRules :: CFG -> CFG
updateRules = union . fromList $ map (fst . last . readP_to_S rule) newRules
  where
    newRules = ["8: 42 | 42 8", "11: 42 31 | 42 11 31"]

main :: IO ()
main = interact $ show . uncurry solve . input empty . lines

input :: CFG -> [String] -> (CFG, [String])
input p ("":xs) = (updateRules p, xs)
input p (x:xs) = input (insert lhs rhs p) xs
  where
    (lhs,rhs) = fst . last . readP_to_S rule $ x

rule :: ReadP (String, RHS)
rule = do
  lhs <- many1 $ satisfy isDigit
  _ <- char ':'
  _ <- skipSpaces
  rhs <- term +++ choose
  return (lhs,rhs)

term :: ReadP RHS
term = Terminal <$> between (char '"') (char '"') get

choose :: ReadP RHS
choose = Choice <$> sepBy1 sequential (skipSpaces *> char '|' <* skipSpaces)

sequential :: ReadP RHS
sequential = Sequence <$> sepBy1 nonterm (char ' ')

nonterm :: ReadP RHS
nonterm = NonTerminal <$> many1 (satisfy isDigit)

makeParser :: CFG -> RHS -> ReadP Char
makeParser _ (Terminal a) = char a
makeParser cfg (Sequence [r]) = makeParser cfg r
makeParser cfg (Sequence (r:rs)) = makeParser cfg r >> makeParser cfg (Sequence rs)
makeParser cfg (Choice [r]) = makeParser cfg r
makeParser cfg (Choice (r:rs)) = makeParser cfg r +++ makeParser cfg (Choice rs)
makeParser cfg (NonTerminal a) = makeParser cfg $ cfg ! a

solve :: CFG -> [String] -> Int
solve cfg = length . filter id . map valid
  where
    parse = readP_to_S $ (makeParser cfg $ NonTerminal "0") <* eof
    valid s = case parse s of (_,""):_ -> True
                              _        -> False
