use std::io;
use std::io::BufRead;

fn main() {
    let mut map = [[[false; 101]; 101]; 101];
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let mut line = line.split_whitespace();
        let on = line.next().unwrap() == "on";
        let mut nums = line.next().unwrap().split(',').flat_map(|d| d[2..].split("..").map(|n| n.parse::<i32>().unwrap()));
        let (minx, maxx) = (nums.next().unwrap(), nums.next().unwrap());
        let (miny, maxy) = (nums.next().unwrap(), nums.next().unwrap());
        let (minz, maxz) = (nums.next().unwrap(), nums.next().unwrap());
        if minx < -50 || maxx > 50 || miny < -50 || maxy > 50 || minz < -50 || maxz > 50 {
            continue;
        }
        for x in minx..=maxx {
            for y in miny..=maxy {
                for z in minz..=maxz {
                    map[(x + 50) as usize][(y + 50) as usize][(z + 50) as usize] = on;
                }
            }
        }
    }
    let mut count = 0;
    for x in 0..=100 {
        for y in 0..=100 {
            for z in 0..=100 {
                if map[x][y][z] {
                    count += 1;
                }
            }
        }
    }
    println!("{}", count);
}
