use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::io;
use std::io::BufRead;
use std::mem;

#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
    cost: usize,
    rooms: [[Option<char>; 2]; 4],
    hallway: [Option<char>; 11],
}

impl State {
    fn estimate_cost(&self) -> usize {
        let mut total = 0;
        for h in 0..11 {
            match self.hallway[h] {
                Some(c) => {
                    let dest = 2 + home(c) * 2;
                    let dist = abs_diff(dest, h) + 1;
                    total += dist * energy(c);
                }
                None => continue,
            }
        }
        for r in 0..4 {
            for p in 0..2 {
                match self.rooms[r][p] {
                    Some(c) if home(c) == r => {
                        if self.rooms[r][p + 1..].iter().any(|&o| o != Some(c)) {
                            total += 4 * energy(c)
                        }
                    }
                    Some(c) => {
                        let dist = 2 * abs_diff(r, home(c)) + 2;
                        total += dist * energy(c);
                    }
                    None => continue,
                }
            }
        }
        total
    }
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        (other.estimate_cost() + other.cost).cmp(&(self.estimate_cost() + self.cost))
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn abs_diff(a: usize, b: usize) -> usize {
    if a > b {
        a - b
    } else {
        b - a
    }
}

fn energy(c: char) -> usize {
    match c {
        'A' => 1,
        'B' => 10,
        'C' => 100,
        'D' => 1000,
        _ => unreachable!(),
    }
}

fn required(room: usize) -> char {
    (b'A' + room as u8) as char
}

fn home(c: char) -> usize {
    (c as u8 - b'A') as usize
}

fn make_move(
    cost: usize,
    mut rooms: [[Option<char>; 2]; 4],
    mut hallway: [Option<char>; 11],
    r: usize,
    p: usize,
    h: usize,
    c: char,
) -> State {
    mem::swap(&mut hallway[h], &mut rooms[r][p]);
    let dc = energy(c) * (1 + p + abs_diff(2 + 2 * r, h));
    State {
        cost: cost + dc,
        hallway,
        rooms,
    }
}

fn search(rooms: [[Option<char>; 2]; 4], hallway: [Option<char>; 11]) -> usize {
    let mut heap = BinaryHeap::new();
    let mut lookup = HashMap::new();

    heap.push(State {
        cost: 0,
        rooms,
        hallway,
    });
    lookup.insert((rooms, hallway), 0);

    while let Some(State {
        cost,
        rooms,
        hallway,
    }) = heap.pop()
    {
        if *lookup.entry((rooms, hallway)).or_insert(cost) < cost {
            continue;
        }
        if rooms
            .iter()
            .enumerate()
            .all(|(i, r)| r[0] == r[1] && r[0] == Some(required(i)))
        {
            return cost;
        }
        let alien_in_room: Vec<_> = rooms
            .iter()
            .enumerate()
            .map(|(i, a)| !a.iter().all(|&o| o.is_none() || o == Some(required(i))))
            .collect();

        // move into room
        'hallway: for h in 0..11 {
            match hallway[h] {
                None => continue,
                Some(c) => {
                    let r = home(c);
                    let dest = 2 + 2 * r;
                    if !alien_in_room[r] {
                        let range = if dest > h {
                            (h + 1)..=dest
                        } else {
                            dest..=h - 1
                        };
                        for pos in range {
                            if hallway[pos].is_some() {
                                continue 'hallway;
                            }
                        }
                        let mut p = 1;
                        if rooms[r][1].is_some() {
                            p -= 1;
                        }
                        heap.push(make_move(cost, rooms, hallway, r, p, h, c))
                    }
                }
            }
        }

        // move out of room
        for r in 0..4 {
            if !alien_in_room[r] {
                continue;
            }
            for p in 0..2 {
                match rooms[r][p] {
                    Some(c)
                        if (c != required(r)
                            || rooms[r][p + 1..]
                                .iter()
                                .any(|c_| c_.unwrap() != required(r))) =>
                    {
                        let mut poss = Vec::new();
                        if hallway[2 + 2 * r].is_none() {
                            for pos in (0..=2 + 2 * r - 1).rev() {
                                if hallway[pos].is_some() {
                                    break;
                                }
                                poss.push(pos);
                            }
                            for pos in 2 + 2 * r + 1..=10 {
                                if hallway[pos].is_some() {
                                    break;
                                }
                                poss.push(pos);
                            }
                        }
                        for pos in poss {
                            heap.push(make_move(cost, rooms, hallway, r, p, pos, c));
                        }
                        break;
                    }
                    _ => continue,
                }
            }
        }
    }
    0
}

fn main() {
    let input: Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).collect();
    let mut rooms = [[None; 2]; 4];
    for i in 0..4 {
        rooms[i][0] = Some(input[2].as_bytes()[3 + 2 * i] as char);
        rooms[i][1] = Some(input[3].as_bytes()[3 + 2 * i] as char);
    }
    let hallway = [None; 11];
    let min_cost = search(rooms, hallway);
    println!("min cost: {}", min_cost);
}
