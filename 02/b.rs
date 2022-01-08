use std::io;
use std::io::BufRead;

fn main() {
    let mut depth = 0;
    let mut horiz = 0;
    let mut aim = 0;

    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        if line.is_empty() {
            continue;
        }
        let split : Vec<_> = line.split_whitespace().collect();
        let cmd = split[0];
        let value = split[1].parse::<i32>().unwrap();
        match cmd {
            "forward" => {
                horiz = horiz + value;
                depth = depth + aim * value;
            },
            "down" => aim = aim + value,
            "up" => aim = aim - value,
            _ => panic!("Unknown command"),
        };
    }
    println!("{}", depth * horiz);
}
