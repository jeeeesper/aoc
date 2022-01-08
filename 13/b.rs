use std::collections::HashSet;
use std::io;
use std::io::BufRead;

fn fold_grid(points : &mut HashSet<(usize, usize)>, dir : char, pos : usize) {
    *points = points.iter().map(|&(x,y)| match dir {
        'x' if x >= pos => (2 * pos - x, y),
        'y' if y >= pos => (x, 2 * pos - y),
        _ => (x,y)
    }).collect();
}

fn main() {
    let mut cmds = Vec::<(char, usize)>::new();
    let mut points = HashSet::<(usize,usize)>::new();
    let mut cmd = false;
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        if line == "" {
            cmd = true;
        } else if cmd {
            let mut split = line.split("=");
            cmds.push((split.next().unwrap().chars().last().unwrap(), split.next().unwrap().parse::<usize>().unwrap()))
        } else {
            let mut split = line.split(",").map(|n| n.parse::<usize>().unwrap());
            points.insert((split.next().unwrap(), split.next().unwrap()));
        }
    }

    for (dir, pos) in cmds {
        fold_grid(&mut points, dir, pos);
    }

    let len_x = points.iter().map(|(x,_)| x).max().unwrap() + 1;
    let len_y = points.iter().map(|(_,y)| y).max().unwrap() + 1;
    for row in 0..len_y {
        for col in 0..len_x {
            if points.contains(&(col,row)) {
                print!("█");
            } else {
                print!("░");
            }
        }
        println!();
    }
}
