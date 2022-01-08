use std::io;
use std::io::BufRead;

fn main() {
    let lines : Vec<Vec<_>> = io::stdin().lock().lines().map(|l| l.unwrap().chars().collect()).collect();
    let num_bits = lines[0].len();
    let mut gamma = 0;
    let mut epsilon = 0;
    for pos in 0..num_bits {
        let ones = lines.iter().filter(|l| l[pos] == '1').count();
        let zeroes = lines.len() - ones;
        let bit = if ones > zeroes {1} else {0};
        gamma = gamma + ( bit << num_bits - pos - 1 );
        epsilon = epsilon + ((1 - bit) << num_bits - pos - 1);
    }
    println!("{}", gamma * epsilon);
}
