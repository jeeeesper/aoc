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
    let mut acc = 0;
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let mut stack : Vec<Enclosing> = Vec::new();
        for (kind, opens) in line.chars().map(|c| identify(c).unwrap()) {
            if opens {
                stack.push(kind);
            } else if kind == *stack.last().unwrap() {
                stack.pop();
            } else {
                match kind {
                    Enclosing::Parenthesis => acc += 3,
                    Enclosing::Bracket => acc += 57,
                    Enclosing::Brace => acc += 1197,
                    Enclosing::Chevron => acc += 25137,
                }
                break;
            }
        }
    }
    println!("{}", acc);
}
