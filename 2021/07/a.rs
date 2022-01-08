use std::io;
use std::io::BufRead;

fn main() {
    let mut input : Vec<_> = io::stdin().lock().lines().next().unwrap().unwrap().split(",").map(|n| n.parse::<i32>().unwrap()).collect();
    input.sort();
    let median = input[input.len() / 2];
    let fuel : i32 = input.into_iter().map(|n| (median - n).abs()).sum();
    println!("{}", fuel);
}
