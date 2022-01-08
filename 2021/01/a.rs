use std::io;
use std::io::BufRead;

fn main() {
    let input : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap().parse::<u32>().unwrap()).collect();
    let mut counter = 0;
    for window in input.windows(2) {
        if window[0] < window[1] {
            counter += 1;
        }
    }
    println!("{}", counter);
}
