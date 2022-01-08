use std::collections::HashSet;
use std::io;
use std::io::BufRead;

struct Image {
    points: HashSet<(i32, i32)>,
    x_bounds: (i32, i32),
    y_bounds: (i32, i32)
}

fn adjust_bounds(image: &mut Image, x: i32, y:i32) {
    if x < image.x_bounds.0 {
        image.x_bounds.0 = x;
    } else if x > image.x_bounds.1 {
        image.x_bounds.1 = x;
    }
    if y < image.y_bounds.0 {
        image.y_bounds.0 = y;
    } else if y > image.y_bounds.1 {
        image.y_bounds.1 = y;
    }
}

fn next_gen(iea: &Vec<bool>, old_img: &Image, pad: bool) -> Image {
    let mut new_img = Image {
        points: HashSet::new(),
        x_bounds: (i32::MAX, i32::MIN),
        y_bounds: (i32::MAX, i32::MIN)
    };
    for x in old_img.x_bounds.0-1..=old_img.x_bounds.1+1 {
        for y in old_img.y_bounds.0-1..=old_img.y_bounds.1+1 {
            let index = (-1..=1).flat_map(|dy| (-1..=1).map(move |dx| {
                let (xdx, ydy) = (x+dx, y+dy);
                if xdx < old_img.x_bounds.0 || xdx > old_img.x_bounds.1
                || ydy < old_img.y_bounds.0 || ydy > old_img.y_bounds.1 {
                    pad
                } else {
                    old_img.points.contains(&(xdx, ydy))
                }
            })).fold(0, |acc, b| (acc << 1) + b as usize);
            if iea[index] {
                new_img.points.insert((x, y));
                adjust_bounds(&mut new_img, x, y);
            }
        }
    }
    new_img
}

fn main() {
    let stdin = io::stdin();
    let mut input = stdin.lock().lines();
    let iea: Vec<bool> = input.next().unwrap().unwrap().chars().map(|c| c == '#').collect();
    input.next();
    let mut img = Image {
        points: HashSet::new(),
        x_bounds: (i32::MAX, i32::MIN),
        y_bounds: (i32::MAX, i32::MIN)
    };
    for (row, cs) in input.enumerate() {
        for (col, c) in cs.unwrap().chars().enumerate() {
            let (x, y) = (col as i32, row as i32);
            if c == '#' {
                img.points.insert((x,y));
                adjust_bounds(&mut img, x, y);
            }
        }
    }
    let mut pad = false;
    let mut toggle = iea[0];
    for _ in 0..50 {
        img = next_gen(&iea, &img, pad);
        if toggle {
            pad = !pad;
        }
        if iea[0b111111111] {
            toggle = false;
        }
    }
    println!("{}", img.points.len());
}
