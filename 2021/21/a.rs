use std::io;
use std::io::BufRead;

fn roll(die: &mut u32) -> (u32, u32, u32) {
    let r = ((*die % 100) + 1, (*die + 1) % 100 + 1, (*die + 2) % 100 + 1);
    *die = (*die + 3) % 100;
    r
}

fn turn(pos: &mut u32, score: &mut u32, diestate: &mut u32) -> bool {
    let (a,b,c) = roll(diestate);
    let sum = a + b + c;
    *pos = (*pos - 1 + sum) % 10 + 1;
    *score += *pos;
    *score >= 1000
}

fn main() {
    let input = io::stdin();
    let mut scores = input
        .lock()
        .lines()
        .map(|l| l
             .unwrap()
             [28..]
             .parse::<u32>()
             .unwrap()
        );
    let (mut p1, mut p2) = (scores.next().unwrap(), scores.next().unwrap());
    let (mut s1, mut s2) = (0, 0);
    let mut count = 0;
    let mut die = 0;
    loop {
        count += 3;
        if turn(&mut p1, &mut s1, &mut die) {
            println!("{}", s2 * count);
            break;
        }
        count += 3;
        if turn(&mut p2, &mut s2, &mut die) {
            println!("{}", s1 * count);
            break;
        }
    }
}
