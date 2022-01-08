use std::io;
use std::io::BufRead;

fn mark(card : &mut Vec<Vec<(u32, bool)>>, draw : u32) {
    for row in card.iter_mut() {
        for (num, marked) in row.iter_mut() {
            if draw == *num {
                *marked = true;
            }
        }
    }
}

fn check(card : &Vec<Vec<(u32, bool)>>, draw : u32) -> Option<u32> {
    // check rows
    for row in card {
        let mut bingo = true;
        for (_, marked) in row {
            bingo = bingo && *marked;
        }
        if bingo {
            return Some(sum(card) * draw);
        }
    }
    // check cols
    for col in 0..card.first().unwrap().len() {
        let mut bingo = true;
        for row in 0..card.len() {
            bingo = bingo && card[row][col].1;
        }
        if bingo {
            return Some(sum(card) * draw);
        }
    }
    { return None; }
}

fn sum(card : &Vec<Vec<(u32, bool)>>) -> u32 {
    card.into_iter().map(|r| r.into_iter().filter(|(_,y)| !*y).map(|(x,_)| *x).sum::<u32>()).sum::<u32>()
}

fn main() {
    let mut cards : Vec<Vec<Vec<(u32, bool)>>> = Vec::new();
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();
    let first_line = lines.next().unwrap().unwrap();
    let draws = first_line.split(",").map(|s| s.parse::<u32>().unwrap());
    for line in lines.map(|l| l.unwrap()) {
        if line.is_empty() {
            cards.push(Vec::new());
            continue;
        }
        cards.last_mut().unwrap().push(line.split_whitespace().map(|s| (s.parse::<u32>().unwrap(), false)).collect());
    }

    for draw in draws {
        for card in cards.iter_mut() {
            mark(card, draw);
            match check(&card, draw) {
                Some(value) => {
                    println!("{}", value);
                    return;
                }
                None => continue,
            }
        }
    }
}
