use std::io;
use std::io::BufRead;

fn apply_moves(map: &mut Vec<Vec<char>>, moves: &Vec<(usize, usize)>, w: usize, h: usize) {
    for &(r, c) in moves {
        match map[r][c] {
            '>' => {
                map[r][c] = '.';
                map[r][(c + 1) % w] = '>';
            }
            'v' => {
                map[r][c] = '.';
                map[(r + 1) % h][c] = 'v';
            }
            _ => unreachable!(),
        }
    }
}

fn step(map: &mut Vec<Vec<char>>, w: usize, h: usize) -> bool {
    let mut change = false;
    let mut moves = Vec::new();
    for r in 0..h {
        for c in 0..w {
            if map[r][c] == '>' && map[r][(c + 1) % w] == '.' {
                moves.push((r, c));
                change = true;
            }
        }
    }
    apply_moves(map, &moves, w, h);
    moves.clear();
    for r in 0..h {
        for c in 0..w {
            if map[r][c] == 'v' && map[(r + 1) % h][c] == '.' {
                moves.push((r, c));
                change = true;
            }
        }
    }
    apply_moves(map, &moves, w, h);
    change
}

fn main() {
    let mut map: Vec<Vec<char>> = Vec::new();
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        map.push(line.chars().collect());
    }
    let (w, h) = (map[0].len(), map.len());
    let mut steps = 1;
    while step(&mut map, w, h) {
        steps += 1;
    }
    println!("{}", steps);
}
