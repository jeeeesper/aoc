use std::io;
use std::io::BufRead;

fn main() {
    let input : Vec<_> = io::stdin().lock().lines().next().unwrap().unwrap().split(",").map(|n| n.parse::<i32>().unwrap()).collect();
    let lower = input.iter().min().unwrap();
    let upper = input.iter().max().unwrap();
    let mut min_fuel = std::i32::MAX;
    for i in *lower..=*upper {
        let fuel = input.iter().map(|n| (i - n).abs() * ((i - n).abs() + 1) / 2).sum();
        if fuel < min_fuel {
            min_fuel = fuel;
        }
    }
    println!("{}", min_fuel);
}
