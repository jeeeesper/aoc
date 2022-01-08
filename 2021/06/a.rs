use std::io;
use std::io::BufRead;

fn main() {
    let mut week : [u32; 7] = [0; 7];
    let fish : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).next().unwrap().split(",").map(|n| n.parse::<u32>().unwrap()).collect();
    for f in fish {
        week[f as usize] = week[f as usize] + 1;
    }
    let mut next = 0;
    let mut nextnext = 0;
    for i in 0..80 {
        let tmp = next;
        next = nextnext;
        nextnext = week[i%7];
        week[i%7] = week[i%7] + tmp;
    }
    println!("{}", week.iter().sum::<u32>() + next + nextnext);
}
