use std::io;
use std::io::BufRead;

#[derive(PartialEq)]
enum Enclosing {
    Parenthesis,
    Bracket,
    Brace,
    Chevron,
}

fn identify(c : char) -> Option<(Enclosing, bool)> {
    match c {
        '(' => Some((Enclosing::Parenthesis, true)),
        ')' => Some((Enclosing::Parenthesis, false)),
        '[' => Some((Enclosing::Bracket, true)),
        ']' => Some((Enclosing::Bracket, false)),
        '{' => Some((Enclosing::Brace, true)),
        '}' => Some((Enclosing::Brace, false)),
        '<' => Some((Enclosing::Chevron, true)),
        '>' => Some((Enclosing::Chevron, false)),
        _ => None,
    }
}

fn main() {
    let mut scores : Vec<u64> = Vec::new();
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let mut corrupted = false;
        let mut stack : Vec<Enclosing> = Vec::new();
        for (kind, opens) in line.chars().map(|c| identify(c).unwrap()) {
            if opens {
                stack.push(kind);
            } else if kind == *stack.last().unwrap() {
                stack.pop();
            } else {
                corrupted = true;
                break;
            }
        }
        if !corrupted {
            let mut acc = 0;
            for c in stack.into_iter().rev() {
                acc *= 5;
                match c {
                    Enclosing::Parenthesis => acc += 1,
                    Enclosing::Bracket => acc += 2,
                    Enclosing::Brace => acc += 3,
                    Enclosing::Chevron => acc += 4,
                }
            }
            scores.push(acc);
        }
    }
    scores.sort();
    println!("{}", scores[scores.len() / 2]);
}
