use std::io;
use std::io::BufRead;

fn main() {
    let input : Vec<Vec<_>> = io::stdin().lock().lines().map(|l| l.unwrap().chars().map(|c| c.to_digit(10).unwrap()).collect()).collect();
    let mut acc = 0;
    for i in 0..input.len() {
        for j in 0..input[i].len() {
            let mut low_point = true;
            let v = input[i][j];
            if i > 0 {
                low_point &= input[i-1][j] > v;
            }
            if i < input.len() - 1 {
                low_point &= input[i+1][j] > v;
            }
            if j > 0 {
                low_point &= input[i][j-1] > v;
            }
            if j < input[i].len() - 1 {
                low_point &= input[i][j+1] > v;
            }
            if low_point {
                acc += 1 + v;
            }
        }
    }
    println!("{}", acc);
}
