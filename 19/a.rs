use std::collections::HashSet;
use std::io;
use std::io::BufRead;

type C3 = (i32, i32, i32);

fn rotate((x,y,z): C3, rot: u8) -> C3 {
  match rot {
    0  => ( x,  y,  z),
    1  => ( x,  z, -y),
    2  => ( x, -y, -z),
    3  => ( x, -z,  y),
    4  => ( y,  x, -z),
    5  => ( y,  z,  x),
    6  => ( y, -x,  z),
    7  => ( y, -z, -x),
    8  => ( z,  x,  y),
    9  => ( z,  y, -x),
    10 => ( z, -x, -y),
    11 => ( z, -y,  x),
    12 => (-x,  y, -z),
    13 => (-x,  z,  y),
    14 => (-x, -y,  z),
    15 => (-x, -z, -y),
    16 => (-y,  x,  z),
    17 => (-y,  z, -x),
    18 => (-y, -x, -z),
    19 => (-y, -z,  x),
    20 => (-z,  x, -y),
    21 => (-z,  y,  x),
    22 => (-z, -x,  y),
    23 => (-z, -y, -x),
    _ => unreachable!()
  }
}

fn arrange(arranged_map: &mut HashSet<C3>, positions: &Vec<C3>) -> bool {
    for rot in 0..24 {
        let positions: Vec<C3> = positions.iter().map(|p| rotate(*p, rot)).collect();
        let distances = positions.iter()
                                 .flat_map(|y| arranged_map.iter().map(move |x| (x, y)))
                                 .map(|((x1,y1,z1), (x2,y2,z2))| (x1-x2, y1-y2, z1-z2));
        for (dx, dy, dz) in distances {
            let trans = positions.iter().map(|(x,y,z)| (x+dx, y+dy, z+dz));
            if trans.clone().filter(|v| arranged_map.contains(v)).count() >= 12 {
                arranged_map.extend(trans);
                return true;
            }
        }
    }
    false
}

fn main() {
    let mut scanners : Vec<Vec<C3>> = Vec::new();
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        if line.is_empty() {
            continue;
        }
        if line.starts_with("---") {
            scanners.push(Vec::new());
            continue;
        }
        let mut cs = line.split(',').map(|c| c.parse::<i32>().unwrap());
        scanners.last_mut().unwrap().push((cs.next().unwrap(), cs.next().unwrap(), cs.next().unwrap()));
    }
    let mut arranged_map : HashSet<C3> = scanners.swap_remove(0).into_iter().collect();
    while !scanners.is_empty() {
        for i in (0..scanners.len()).rev() {
            if arrange(&mut arranged_map, &scanners[i]) {
                scanners.swap_remove(i);
            }
        }
    }
    println!("{}", arranged_map.len());
}
