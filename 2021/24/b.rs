use std::{io::{self, BufRead}, collections::HashMap};

enum Argument {
    Reg(usize),
    Val(i64),
}

impl Argument {
    fn to_val(&self, reg: &[i64; 4]) -> i64 {
        match self {
            Argument::Reg(r) => reg[*r],
            Argument::Val(v) => *v,
        }
    }
}

enum Instruction {
    Inp(usize),
    Add(usize, Argument),
    Mul(usize, Argument),
    Div(usize, Argument),
    Mod(usize, Argument),
    Eql(usize, Argument),
}

#[derive(PartialEq, Eq, Hash, Clone, Copy)]
struct ALU {
    reg: [i64; 4],
}

impl ALU {
    fn exec(&mut self, ins: &Instruction) {
        match ins {
            Instruction::Inp(_) => panic!(),
            Instruction::Add(a, b) => {
                self.reg[*a] += b.to_val(&self.reg);
            }
            Instruction::Mul(a, b) => {
                self.reg[*a] *= b.to_val(&self.reg);
            }
            Instruction::Div(a, b) => {
                self.reg[*a] /= b.to_val(&self.reg);
            }
            Instruction::Mod(a, b) => {
                self.reg[*a] %= b.to_val(&self.reg);
            }
            Instruction::Eql(a, b) => {
                self.reg[*a] = if self.reg[*a] == b.to_val(&self.reg) {
                    1
                } else {
                    0
                };
            }
        }
    }
    fn input(&mut self, r: usize, n: i64) {
        self.reg[r] = n;
    }
}

fn reg_to_ix(reg: char) -> usize {
    match reg {
        'w' => 0,
        'x' => 1,
        'y' => 2,
        'z' => 3,
        _ => unreachable!(),
    }
}

fn search(program: &Vec<Instruction>) -> u64 {
    let mut alus = vec![(ALU { reg: [0; 4] }, 0)];
    for ins in program {
        match *ins {
            Instruction::Inp(r) => {
                let mut new_alus: Vec<(ALU, u64)> = Vec::new();
                let mut ixs: HashMap<ALU, usize> = HashMap::new();
                for alu in &alus {
                    for d in 1..=9 {
                        let mut new_alu = alu.clone();
                        new_alu.0.input(r, d);
                        new_alu.1 = new_alu.1 * 10 + d as u64;
                        if let Some(ix) = ixs.get(&new_alu.0) {
                            new_alus[*ix].1 = u64::min(new_alus[*ix].1, new_alu.1);
                        } else {
                            ixs.insert(new_alu.0.clone(), new_alus.len());
                            new_alus.push(new_alu);
                        }
                    }
                }
                alus = new_alus;
            }
            _ => {
                for alu in &mut alus {
                    alu.0.exec(&ins);
                }
            }
        }
    }
    let mut lowest = u64::MAX;
    for alu in &alus {
        if alu.0.reg[3] == 0 {
            lowest = u64::min(lowest, alu.1);
        }
    }
    lowest
}

fn main() {
    let mut program = Vec::new();
    for line in io::stdin().lock().lines().map(|l| l.unwrap()) {
        let mut split = line.split_whitespace();
        let kw = split.next().unwrap();
        let a = reg_to_ix(split.next().unwrap().chars().nth(0).unwrap());
        let b = split.next().map(|b| {
            b.parse::<i64>()
                .map(|b_| Argument::Val(b_))
                .unwrap_or_else(|_| Argument::Reg(reg_to_ix(b.chars().nth(0).unwrap())))
        });
        let ins = match kw {
            "inp" => Instruction::Inp(a),
            "add" => Instruction::Add(a, b.unwrap()),
            "mul" => Instruction::Mul(a, b.unwrap()),
            "div" => Instruction::Div(a, b.unwrap()),
            "mod" => Instruction::Mod(a, b.unwrap()),
            "eql" => Instruction::Eql(a, b.unwrap()),
            _ => unreachable!(),
        };
        program.push(ins);
    }
    println!("{}", search(&program));
}
