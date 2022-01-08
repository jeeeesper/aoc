use std::io;
use std::io::BufRead;

fn throw(x : i32, y : i32, vx : i32, vy : i32, minx : i32, maxx : i32, miny : i32, maxy : i32) -> bool {
    if x > maxx || y < miny {
        false
    } else if x >= minx && y <= maxy {
        true
    } else {
        throw(x + vx, y + vy, if vx > 0 { vx - 1 } else { 0 }, vy - 1, minx, maxx, miny, maxy)
    }
}

fn main() {
    let string = &io::stdin().lock().lines().next().unwrap().unwrap()[15..];
    let mut split = string.split(',');
    let (minx, maxx) = split.next().unwrap().split("..").fold((0,0), |(_,b), c| (b, c.parse::<i32>().unwrap()));
    let (miny, maxy) = split.next().unwrap()[3..].split("..").fold((0,0), |(_,b), c| (b, c.parse::<i32>().unwrap()));

    let mut count = 0;
    for vx in 1..maxx+1 {
        for vy in miny..-miny {
            count += throw(0, 0, vx, vy, minx, maxx, miny, maxy) as u32;
        }
    }

    println!("{}", count);
}
