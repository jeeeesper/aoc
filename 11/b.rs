use std::io;
use std::io::BufRead;

fn flash(grid : &mut Vec<Vec<u32>>, i : usize, j : usize, flashed : &mut Vec<Vec<bool>>) {
    if flashed[i][j] {
        return;
    }
    flashed[i][j] = true;
    for k in (i as i32)-1..=(i as i32)+1 {
        if k < 0 || k >= grid.len() as i32 {
            continue;
        }
        for l in (j as i32)-1..=(j as i32)+1 {
            match grid[k as usize].get(l as usize) {
                None => continue,
                Some(_) => {
                    if k as usize == i && l as usize == j {
                        continue;
                    }
                    grid[k as usize][l as usize] += 1;
                    if grid[k as usize][l as usize] == 10 {
                        flash(grid, k as usize, l as usize, flashed);
                    }
                }
            }
        }
    }
}

fn main() {
    let mut grid : Vec<Vec<_>> = io::stdin().lock().lines().map(|l| l.unwrap().chars().map(|c| c.to_digit(10).unwrap()).collect()).collect();
    let mut iteration = 0;
    loop {
        iteration += 1;
        let mut flashed = vec![vec![false; grid[0].len()]; grid.len()];

        for i in 0..grid.len() {
            for j in 0..grid[i].len() {
                grid[i][j] += 1;
                if grid[i][j] > 9 {
                    flash(&mut grid, i, j, &mut flashed);
                }
            }
        }
        let mut all = true;
        for i in 0..grid.len() {
            for j in 0..grid[i].len() {
                if flashed[i][j] {
                    grid[i][j] = 0;
                } else {
                    all = false;
                }
            }
        }
        if all {
            break;
        }
    }
    println!("{}", iteration);
}
