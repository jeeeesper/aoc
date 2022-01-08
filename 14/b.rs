use std::collections::HashMap;
use std::io;
use std::io::BufRead;

fn main() {
    let stdin = io::stdin();
    let mut input = stdin.lock().lines();
    let first_line = input.next().unwrap().unwrap();
    let mut counts : HashMap<(char, char), usize> = HashMap::new();
    for w in first_line.as_bytes().windows(2) {
        *counts.entry((w[0] as char, w[1] as char)).or_insert(0) += 1;
    }
    input.next();
    let mut rules : HashMap<(char, char), char> = HashMap::new();
    for line in input.map(|l| l.unwrap()) {
        let mut split = line.split(" -> ");
        let mut lhs = split.next().unwrap().chars();
        let (a, b) = (lhs.next().unwrap(), lhs.next().unwrap());
        let c = split.next().unwrap().chars().next().unwrap();
        rules.insert((a, b), c);
    }

    for _ in 0..40 {
        let mut new_counts : HashMap<(char, char), usize> = HashMap::new();
        for ((a, b), n) in counts {
            let c = *rules.get(&(a,b)).unwrap();
            *new_counts.entry((a,c)).or_insert(0) += n;
            *new_counts.entry((c,b)).or_insert(0) += n;
        }
        counts = new_counts;
    }

    let mut quantities : HashMap<char, usize> = HashMap::new();
    for ((a,_), n) in counts {
        *quantities.entry(a).or_insert(0) += n;
    }
    *quantities.entry(first_line.chars().last().unwrap()).or_insert(0) += 1;

    let max = quantities.values().max().unwrap();
    let min = quantities.values().min().unwrap();

    println!("{}", max - min);
}
