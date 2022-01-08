use std::cmp;
use std::io;
use std::io::BufRead;

fn main() {
    let input : Vec<_> = io::stdin().lock().lines().next().unwrap().unwrap().split(",").map(|n| n.parse::<i32>().unwrap()).collect();
    let mean = input.iter().sum::<i32>() as f32 / input.len() as f32;
    let mean_floor : i32 = mean.floor() as i32;
    let mean_ceil : i32 = mean.ceil() as i32;
    let fuel_floor : i32 = input.iter().map(|n| (mean_floor - n).abs() * ((mean_floor - n).abs() + 1) / 2).sum();
    let fuel_ceil : i32 = input.iter().map(|n| (mean_ceil - n).abs() * ((mean_ceil - n).abs() + 1) / 2).sum();
    println!("{}", cmp::min(fuel_floor, fuel_ceil));
}
