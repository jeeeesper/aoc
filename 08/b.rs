use std::collections::HashMap;
use std::io;
use std::io::BufRead;

fn main() {
    let lines : Vec<_> = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .collect();
    let mut result = 0;
    for line in lines {
        let split : Vec<Vec<u8>>
            = line.split(" | ")
                  .map(|s| s
                       .split(" ")
                       .map(|h| h
                            .chars()
                            .map(|c| 1 << (c as u8 - b'a'))
                            .reduce(|acc, elem| acc | elem)
                            .unwrap()
                       ).collect()
                  ).collect();
        let clues = &split[0];
        let digits = &split[1];
        let (mut two, mut three, mut four, mut five, mut six)
            = (0x7f,0x7f,0x7f,0x7f,0x7f);
        for clue in clues {
            match clue.count_ones() {
                2 => two = two & clue,
                3 => three = three & clue,
                4 => four = four & clue,
                5 => five = five & clue,
                6 => six = six & clue,
                7 => (),
                _ => println!("Ich raste aus!"),
            }
        }
        let a = three & !two;
        let b = four & !two & !five;
        let c = two & !six;
        let d = four & five;
        let e = 0x7f & !four & !five;
        let f = two & six;
        let g = six & five & !a;

        let mut num = HashMap::new();
        num.insert(a|b|c|e|f|g, 0);
        num.insert(c|f, 1);
        num.insert(a|c|d|e|g, 2);
        num.insert(a|c|d|f|g, 3);
        num.insert(b|c|d|f, 4);
        num.insert(a|b|d|f|g, 5);
        num.insert(a|b|d|e|f|g, 6);
        num.insert(a|c|f, 7);
        num.insert(a|b|c|d|e|f|g, 8);
        num.insert(a|b|c|d|f|g, 9);
        result += digits.into_iter().fold(0, |acc, d| 10 * acc + num[&d]);
    }
    println!("{}", result);
}
