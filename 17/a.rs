use std::io;
use std::io::BufRead;

fn main() {
    let string = &io::stdin().lock().lines().next().unwrap().unwrap()[15..];
    let mut split = string.split(',');
    let (_, _) = split.next().unwrap().split("..").fold((0,0), |(_,b), c| (b, c.parse::<i32>().unwrap()));
    let (miny, _) = split.next().unwrap()[3..].split("..").fold((0,0), |(_,b), c| (b, c.parse::<i32>().unwrap()));

    println!("{}", (-miny) * (-miny - 1) / 2);
}
