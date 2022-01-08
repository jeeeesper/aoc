use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::io;
use std::io::BufRead;

fn dijkstra(map : &Vec<Vec<u32>>, (start_x, start_y) : (usize, usize), end : (usize, usize)) -> u32 {
    let max_x = map.len();
    let max_y = map[0].len();

    let mut dist = vec![vec![u32::MAX; max_y]; max_x];
    let mut q = BinaryHeap::new();
    q.push((Reverse(0), start_x, start_y));
    while let Some((Reverse(d), x, y)) = q.pop() {
        if d > dist[x][y] {
            continue;
        }
        if (x, y) == end {
            return d;
        }
        for (x0, y0) in [(x as i32-1,y as i32),(x as i32+1,y as i32),(x as i32,y as i32-1),(x as i32,y as i32+1)] {
            if x0 < 0 || x0 >= max_x as i32 || y0 < 0 || y0 >= max_y as i32 {
                continue;
            }
            let (cx, cy) = (x0 as usize, y0 as usize);
            let new_dist = d + map[cx][cy];
            if new_dist < dist[cx][cy] {
                q.push((Reverse(new_dist), cx, cy));
                dist[cx][cy] = new_dist;
            }
        }
    }
    unreachable!();
}

fn main() {
    let repeat = 5;
    let mut cavern = Vec::new();
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let levels : Vec<_> = line.chars().map(|c| c.to_digit(10).unwrap()).collect();
        cavern.push(levels);
    }
    let (len_x, len_y) = (cavern.len(), cavern[0].len());
    let (ex_len_x, ex_len_y) = (len_x * repeat, len_y * repeat);
    let mut expanded_cavern = vec![vec![0; ex_len_y]; ex_len_x];
    for x in 0..ex_len_x {
        for y in 0..ex_len_y {
            expanded_cavern[x][y] = (cavern[x % len_x][y % len_y]
                                     + (x as u32 / len_x as u32)
                                     + (y as u32 / len_y as u32) - 1) % 9 + 1;
        }
    }
    println!("{}", dijkstra(&expanded_cavern, (0,0), (ex_len_x - 1, ex_len_y-1)));
}
