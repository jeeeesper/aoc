use std::collections::BTreeSet;
use std::io;
use std::io::BufRead;

struct Step {
    on: bool,
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
    min_z: i32,
    max_z: i32
}

fn main() {
    let mut xs: BTreeSet<i32> = BTreeSet::new();
    let mut ys: BTreeSet<i32> = BTreeSet::new();
    let mut zs: BTreeSet<i32> = BTreeSet::new();
    let mut steps: Vec<Step> = Vec::new();
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let mut line = line.split_whitespace();
        let on = line.next().unwrap() == "on";
        let mut nums = line.next().unwrap().split(',').flat_map(|d| d[2..].split("..").map(|n| n.parse::<i32>().unwrap()));
        let (min_x, max_x) = (nums.next().unwrap(), nums.next().unwrap());
        let (min_y, max_y) = (nums.next().unwrap(), nums.next().unwrap());
        let (min_z, max_z) = (nums.next().unwrap(), nums.next().unwrap());
        xs.insert(min_x);
        xs.insert(max_x + 1);
        ys.insert(min_y);
        ys.insert(max_y + 1);
        zs.insert(min_z);
        zs.insert(max_z + 1);
        steps.push(Step { on, min_x, max_x, min_y, max_y, min_z, max_z });
    }
    let mut map = vec![vec![vec![false; zs.len()-1]; ys.len()-1]; xs.len()-1];
    for Step { on, min_x, max_x, min_y, max_y, min_z, max_z } in steps {
        let (lx, ux) = (xs.iter().position(|&x| x == min_x).unwrap(), xs.iter().position(|&x| x > max_x).unwrap());
        let (ly, uy) = (ys.iter().position(|&y| y == min_y).unwrap(), ys.iter().position(|&y| y > max_y).unwrap());
        let (lz, uz) = (zs.iter().position(|&z| z == min_z).unwrap(), zs.iter().position(|&z| z > max_z).unwrap());
        for x in lx..ux  {
            for y in ly..uy {
                for z in lz..uz {
                    map[x][y][z] = on;
                }
            }
        }
    }
    let mut result: u64 = 0;
    let mut xi = xs.iter();
    let mut xl = xi.next().unwrap();
    let mut xn = 0;
    for x in xi {
        let mut yi = ys.iter();
        let mut yl = yi.next().unwrap();
        let mut yn = 0;
        for y in yi {
            let mut zi = zs.iter();
            let mut zl = zi.next().unwrap();
            let mut zn = 0;
            for z in zi {
                if map[xn][yn][zn] {
                    result += (x-xl) as u64 * (y-yl) as u64 * (z-zl) as u64;
                }
                zl = z;
                zn += 1;
            }
            yl = y;
            yn += 1;
        }
        xl = x;
        xn += 1;
    }
    println!("{}", result);
}
