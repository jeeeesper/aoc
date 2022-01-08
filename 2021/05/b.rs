use std::cmp;
use std::io;
use std::io::BufRead;
use std::collections::HashMap;

fn main() {
    let mut points = HashMap::new();
    let mut counter = 0;
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let coords : Vec<Vec<i32>> = line.split(" -> ").map(|s| s.split(",").map(|n| n.parse::<i32>().unwrap()).collect()).collect();
        if coords[0][0] == coords[1][0] {
            let lower = cmp::min(coords[0][1], coords[1][1]);
            let upper = cmp::max(coords[0][1], coords[1][1]);
            for n in lower..upper+1 {
                let val = points.entry((coords[0][0], n)).or_insert(0);
                if *val == 1 {
                    counter = counter + 1;
                }
                *val = *val + 1;
            }
        } else if coords[0][1] == coords[1][1] {
            let lower = cmp::min(coords[0][0], coords[1][0]);
            let upper = cmp::max(coords[0][0], coords[1][0]);
            for n in lower..upper+1 {
                let val = points.entry((n, coords[0][1])).or_insert(0);
                if *val == 1 {
                    counter = counter + 1;
                }
                *val = *val + 1;
            }
        } else {
            let delta_x = if coords[0][0] < coords[1][0] { 1 } else { -1 };
            let delta_y = if coords[0][1] < coords[1][1] { 1 } else { -1 };
            let mut x = coords[0][0];
            let mut y = coords[0][1];
            for _ in 0..(coords[0][0] - coords[1][0]).abs()+1 {
                let val = points.entry((x, y)).or_insert(0);
                if *val == 1 {
                    counter = counter + 1;
                }
                *val = *val + 1;
                x = x + delta_x;
                y = y + delta_y;
            }
        }
    }
    println!("{}", counter);
}
