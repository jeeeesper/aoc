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

    let (dir, pos) = cmds[0];
    fold_grid(&mut points, dir, pos);

    println!("{}", points.len());
}
