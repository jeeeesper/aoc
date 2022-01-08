use std::cmp;
use std::collections::HashMap;
use std::io;
use std::io::BufRead;

fn play(p1: u64, p2: u64, s1: u64, s2: u64, dp: &mut HashMap<(u64, u64, u64, u64), (u64, u64)>) -> (u64, u64) {
    if s1 >= 21 {
        return (1, 0);
    }
    if s2 >= 21 {
        return (0, 1);
    }
    return match dp.get(&(p1, p2, s1, s2)) {
        Some(v) => *v,
        None => {
            let (mut w1, mut w2) = (0, 0);
            for a in 1..=3 {
                for b in 1..=3 {
                    for c in 1..=3 {
                        let p1_ = (p1 - 1 + a + b + c) % 10 + 1;
                        let s1_ = s1 + p1_;
                        let (dw2, dw1) = play(p2, p1_, s2, s1_, dp);
                        w1 += dw1;
                        w2 += dw2;
                    }
                }
            }
            dp.insert((p1, p2, s1, s2), (w1, w2));
            (w1, w2)
        }
    }
}

fn main() {
    let input = io::stdin();
    let mut scores = input
        .lock()
        .lines()
        .map(|l| l
             .unwrap()
             [28..]
             .parse::<u64>()
             .unwrap()
        );
    let (p1, p2) = (scores.next().unwrap(), scores.next().unwrap());
    let mut dp = HashMap::new();
    let (w1, w2) = play(p1, p2, 0, 0, &mut dp);
    println!("{}", cmp::max(w1, w2));
}
