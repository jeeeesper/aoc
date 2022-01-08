use std::io;
use std::io::BufRead;
use std::iter;
use std::vec::IntoIter;

struct Packet {
    _version: u8,
    type_id: u8,
    payload: Payload
}

enum Payload {
    Literal(u64),
    Packets(Vec<Packet>)
}

fn parse_literal(bits : &mut IntoIter<u8>) -> Option<u64> {
    let mut num : u64 = 0;
    loop {
        let mark = bits.next()?;
        let part = bits.take(4).fold(0, |acc, b| 2 * acc + b);
        num = num << 4 | part as u64;
        if mark == 0 {
            break;
        }
    }
    Some(num)
}

fn parse_operator(bits : &mut IntoIter<u8>) -> Option<Vec<Packet>> {
    let packets = match bits.next()? {
        0 => {
            let n = bits.take(15).fold(0, |acc, b| 2 * acc + b as u64);
            let mut bits = bits.take(n as usize).collect::<Vec<_>>().into_iter();
            iter::from_fn(|| parse_packet(&mut bits)).collect()
        },
        1 => {
            let n = bits.take(11).fold(0, |acc, b| 2 * acc + b as u64);
            iter::repeat_with(|| parse_packet(bits).unwrap()).take(n as usize).collect()
        },
        _ => unreachable!()
    };
    Some(packets)
}

fn parse_packet(bits : &mut IntoIter<u8>) -> Option<Packet> {
    let version = bits.take(3).fold(0, |acc, b| 2 * acc + b);
    let type_id = bits.take(3).fold(0, |acc, b| 2 * acc + b);
    let payload = match type_id {
        4 => Payload::Literal(parse_literal(bits)?),
        _ => Payload::Packets(parse_operator(bits)?),
    };
    Some(Packet { _version: version, type_id: type_id, payload: payload })
}

fn eval(p : &Packet) -> u64 {
    match &p.payload {
        Payload::Literal(v) => *v,
        Payload::Packets(ps) => match p.type_id {
            0 => ps.iter().map(eval).sum(),
            1 => ps.iter().map(eval).product(),
            2 => ps.iter().map(eval).min().unwrap(),
            3 => ps.iter().map(eval).max().unwrap(),
            5 => (eval(&ps[0]) > eval(&ps[1])) as u64,
            6 => (eval(&ps[0]) < eval(&ps[1])) as u64,
            7 => (eval(&ps[0]) == eval(&ps[1])) as u64,
            _ => unreachable!()
        }
    }
}

fn main() {
    let line = io::stdin().lock().lines().next().unwrap().unwrap();
    let bits : Vec<u8> = line.chars().flat_map(|c| {
        let d = c.to_digit(16).unwrap() as u8;
        (0..4).rev().map(move |i| (d >> i) & 0b1)
    }).collect();
    let packets = parse_packet(&mut bits.into_iter()).unwrap();
    println!("{}", eval(&packets));
}
