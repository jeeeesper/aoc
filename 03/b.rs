use std::io;
use std::io::BufRead;

fn main() {
    let mut o2lines : Vec<Vec<_>> = io::stdin().lock().lines().map(|l| l.unwrap().chars().collect()).collect();
    let mut co2lines = o2lines.to_vec();
    let num_bits = o2lines[0].len();
    for pos in 0..num_bits {
        let ones = o2lines.iter().filter(|l| l[pos] == '1').count();
        let zeroes = o2lines.len() - ones;
        if ones >= zeroes {
            o2lines.retain(|l| l[pos] == '1');
        } else {
            o2lines.retain(|l| l[pos] == '0');
        }
        if o2lines.len() == 1 {
            break;
        }
    }
    for pos in 0..num_bits {
        let ones = co2lines.iter().filter(|l| l[pos] == '1').count();
        let zeroes = co2lines.len() - ones;
        if ones < zeroes {
            co2lines.retain(|l| l[pos] == '1');
        } else {
            co2lines.retain(|l| l[pos] == '0');
        }
        if co2lines.len() == 1 {
            break;
        }
    }
    let o2 = isize::from_str_radix(&o2lines[0].iter().collect::<String>(), 2).unwrap();
    let co2 = isize::from_str_radix(&co2lines[0].iter().collect::<String>(), 2).unwrap();
    println!("{}", o2*co2);
}
