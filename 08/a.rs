use std::io;
use std::io::BufRead;

fn main() {
    let lines : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).collect();
    let nums : Vec<_> = vec![2,3,4,7];
    let mut counter = 0;
    for line in lines {
        let snd : Vec<_> = line.split(" | ").collect();
        let xs : Vec<_> = snd[1].split(" ").collect();
        for x in xs {
            if nums.contains(&x.chars().count()) {
                counter = counter + 1;
            }
        }
    }
    println!("{}", counter);
}
