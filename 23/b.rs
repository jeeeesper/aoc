use std::cmp;
use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::io;
use std::io::BufRead;
use std::mem;

#[derive(Copy, Clone, Eq, PartialEq, Hash)]
struct State<const D: usize> {
    rooms: [[Option<char>; D]; 4],
    hallway: [Option<char>; 11],
}

impl<const D: usize> State<D> {
    fn target() -> Self {
        Self {
            rooms: [
                [Some('A'); D],
                [Some('B'); D],
                [Some('C'); D],
                [Some('D'); D],
            ],
            hallway: [None; 11],
        }
    }

    fn make_move(&self, r: usize, p: usize, h: usize) -> Self {
        let mut nr = self.rooms;
        let mut nh = self.hallway;
        mem::swap(&mut nh[h], &mut nr[r][p]);
        Self {
            rooms: nr,
            hallway: nh,
        }
    }

    fn estimate_cost(&self) -> usize {
        let mut total = 0;
        for h in 0..11 {
            match self.hallway[h] {
                Some(c) => {
                    let dest = 2 + home(c) * 2;
                    total += abs_diff(dest, h) * energy(c);
                }
                None => continue,
            }
        }
        for r in 0..4 {
            let has_to_move_out = self.rooms[r]
                .iter()
                .enumerate()
                .rev()
                .filter_map(|(d, &o)| o.map(|c| (d, c)))
                .skip_while(move |&(_, c)| home(c) == r);
            for (p, c) in has_to_move_out {
                let hallway_steps = cmp::max(abs_diff(r, home(c)) * 2, 2);
                total += energy(c) * (p + 1 + hallway_steps);
            }
            let has_to_enter_room = self.rooms[r]
                .iter()
                .enumerate()
                .rev()
                .skip_while(move |&(_, o)| o.is_some() && home(o.unwrap()) == r);
            for (p, _) in has_to_enter_room {
                total += (p + 1) * energy(required(r));
            }
        }
        total
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
struct HeapEntry<const D: usize> {
    cost: usize,
    state: State<D>,
}

impl<const D: usize> Ord for HeapEntry<D> {
    fn cmp(&self, other: &Self) -> Ordering {
        (other.state.estimate_cost() + other.cost).cmp(&(self.state.estimate_cost() + self.cost))
    }
}

impl<const D: usize> PartialOrd for HeapEntry<D> {
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

fn transition<const D: usize>(
    queue: &mut BinaryHeap<HeapEntry<D>>,
    lookup: &mut HashMap<State<D>, usize>,
    state: State<D>,
    r: usize,
    p: usize,
    h: usize,
    c: char,
    cost: usize,
) {
    let new_state = state.make_move(r, p, h);
    let dc = energy(c) * (1 + p + abs_diff(2 + 2 * r, h));
    if *lookup.get(&new_state).unwrap_or(&usize::MAX) > cost + dc {
        queue.push(HeapEntry {
            cost: cost + dc + new_state.estimate_cost(),
            state: new_state,
        });
        lookup.insert(new_state, cost + dc);
    }
}

fn search<const R: usize>(init_state: State<R>) -> usize {
    let mut heap = BinaryHeap::new();
    let mut lookup = HashMap::new();

    heap.push(HeapEntry {
        cost: init_state.estimate_cost(),
        state: init_state,
    });
    lookup.insert(init_state, 0);

    while let Some(HeapEntry { cost: _, state }) = heap.pop() {
        let cost = *lookup.get(&state).unwrap();
        if state == State::target() {
            return cost;
        }
        let &rooms = &state.rooms;
        let &hallway = &state.hallway;

        // move into room
        'hallway_loop: for h in 0..11 {
            match hallway[h] {
                None => continue 'hallway_loop,
                Some(c) => {
                    let home = home(c);
                    let home_x = 2 + 2 * home;
                    let can_enter = rooms[home].iter().all(|o| match o {
                        None => true,
                        Some(c_) => c == *c_,
                    });
                    if !can_enter {
                        continue 'hallway_loop;
                    }
                    let range = if h > home_x {
                        home_x..=h - 1
                    } else {
                        h + 1..=home_x
                    };
                    let clear = hallway[range].iter().all(|o| o.is_none());
                    if !clear {
                        continue 'hallway_loop;
                    }
                    let pos = rooms[home].iter().rposition(|o| o.is_none()).unwrap();
                    transition(&mut heap, &mut lookup, state, home, pos, h, c, cost);
                }
            }
        }

        // move out of room
        'room_loop: for r in 0..4 {
            let room_x = 2 + 2 * r;
            let can_enter = rooms[r].iter().all(|o| match o {
                None => true,
                Some(c) => c == &required(r),
            });
            if can_enter {
                // then we shouldn't move out
                continue 'room_loop;
            }
            let (p, c) = rooms[r]
                .iter()
                .enumerate()
                .find_map(|(p, o)| o.map(|c| (p, c)))
                .unwrap();
            let left = (0..room_x).rev().take_while(|x| hallway[*x].is_none());
            let right = (room_x + 1..11).take_while(|x| hallway[*x].is_none());
            for h in left.chain(right) {
                if h % 2 == 0 && h / 2 >= 1 && h / 2 <= 4 {
                    continue;
                }
                transition(&mut heap, &mut lookup, state, r, p, h, c, cost);
            }
        }
    }
    0
}

fn main() {
    let to_insert = [['D', 'C', 'B', 'A'], ['D', 'B', 'A', 'C']];
    let input: Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).collect();
    let mut rooms = [[None; 4]; 4];
    for i in 0..4 {
        rooms[i][0] = Some(input[2].as_bytes()[3 + 2 * i] as char);
        rooms[i][1] = Some(to_insert[0][i]);
        rooms[i][2] = Some(to_insert[1][i]);
        rooms[i][3] = Some(input[3].as_bytes()[3 + 2 * i] as char);
    }
    let hallway = [None; 11];

    let min_cost = search(State { rooms, hallway });
    println!("{}", min_cost);
}
