use std::io;
use std::io::BufRead;

#[derive(Clone)]
enum SN {
    Num(i32),
    Pair(Box<SN>, Box<SN>)
}

fn add_l(x : SN, n : i32) -> SN {
    match x {
        SN::Pair(a, b) => {
            SN::Pair(Box::new(add_l(*a.clone(), n)), b)
        },
        SN::Num(m) => SN::Num(n + m)
    }
}

fn add_r(x : SN, n : i32) -> SN {
    match x {
        SN::Pair(a, b) => {
            SN::Pair(a, Box::new(add_r(*b.clone(), n)))
        },
        SN::Num(m) => SN::Num(n + m)
    }
}

fn split(x : SN) -> Option<SN> {
    match x {
        SN::Num(n) if n >= 10 => Some(SN::Pair(Box::new(SN::Num(n / 2)), Box::new(SN::Num((n+1) / 2)))),
        SN::Pair(a, b) => match split(*a.clone()) {
            Some(aa) => Some(SN::Pair(Box::new(aa), b)),
            None => match split(*b.clone()) {
                Some(bb) => Some(SN::Pair(a, Box::new(bb))),
                None => None
            }
        }
        _ => None
    }
}

fn explode(x : SN, depth : u32) -> Option<(SN, i32, i32)> {
    if let SN::Pair(a, b) = x {
        if depth == 4 {
            if let (SN::Num(a), SN::Num(b)) = (*a, *b) {
                Some((SN::Num(0), a, b))
            } else {
                None
            }
        } else {
            match explode(*a.clone(), depth + 1) {
                Some((aa, an, bn)) => Some((SN::Pair(Box::new(aa), Box::new(add_l(*b, bn))), an, 0)),
                None => match explode(*b, depth + 1) {
                    Some((bb, an, bn)) => Some((SN::Pair(Box::new(add_r(*a, an)), Box::new(bb)), 0, bn)),
                    None => None
                }
            }
        }
    } else {
        None
    }
}

fn reduce(x : SN) -> SN {
    match explode(x.clone(), 0) {
        Some((y, _, _)) => reduce(y),
        None => match split(x.clone()) {
            Some(y) => reduce(y),
            None => x
        }
    }
}

fn parse_num(tokens : &mut dyn Iterator<Item = char>) -> Option<SN> {
    match tokens.next()? {
        '[' => {
            let lhs = parse_num(tokens)?;
            assert_eq!(',', tokens.next()?);
            let rhs = parse_num(tokens)?;
            assert_eq!(']', tokens.next()?);
            Some(SN::Pair(Box::new(lhs), Box::new(rhs)))
        },
        n => Some(SN::Num(n.to_digit(10).unwrap() as i32))
    }
}

fn magnitude(x : SN) -> i32 {
    match x {
        SN::Num(n) => n,
        SN::Pair(a, b) => 3 * magnitude(*a) + 2 * magnitude(*b)
    }
}

fn main() {
    let lines : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).collect();
    let result = lines.into_iter()
                      .map(|line| parse_num(&mut line.chars()).unwrap())
                      .reduce(|a,b| reduce(SN::Pair(Box::new(a), Box::new(b))))
                      .unwrap();

    println!("{}", magnitude(result));
}
