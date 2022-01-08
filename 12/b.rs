use std::collections::HashMap;
use std::collections::HashSet;
use std::io;
use std::io::BufRead;

fn count_paths<'a>(graph : &HashMap::<&'a str, Vec<&'a str>>, mut visited : HashSet<&'a str>, v : &'a str, mut duplicate : bool) -> u32 {
    if v == "end" {
        return 1;
    }
    if v == "start" && !visited.is_empty() {
        return 0;
    }
    if v.to_lowercase() == v && visited.contains(v) {
        if duplicate {
            return 0;
        } else {
            duplicate = true;
        }
    }
    visited.insert(v.clone());
    let mut sum = 0;
    for w in &graph[&v] {
        sum += count_paths(graph, visited.clone(), w, duplicate);
    }
    return sum;
}

fn main() {
    let lines : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).collect();
    let mut graph = HashMap::<&str, Vec<&str>>::new();
    for mut line in lines.iter().map(|l| l.split("-")) {
        let tail = line.next().unwrap();
        let head = line.next().unwrap();
        graph.entry(tail).or_default().push(head);
        graph.entry(head).or_default().push(tail);
    }

    let visited = HashSet::<&str>::new();
    println!("{}", count_paths(&graph, visited, "start", false));
}
