const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

const Ident = [3]u8;
const AdjList = std.AutoHashMap(Ident, std.ArrayList(Ident));

pub fn main() !void {
    var succ = AdjList.init(std.heap.page_allocator);
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        const colon = std.mem.findScalar(u8, line, ':').?;
        var this: Ident = undefined;
        std.mem.copyForwards(u8, &this, line[0..colon]);
        var succ_it = std.mem.tokenizeScalar(u8, line[colon + 1 ..], ' ');
        var successors = std.ArrayList(Ident).empty;
        while (succ_it.next()) |successor| {
            var buf: Ident = undefined;
            std.mem.copyForwards(u8, &buf, successor);
            try successors.append(std.heap.page_allocator, buf);
        }
        try succ.put(this, successors);
    }

    const result = try count_paths(succ);

    try print("{d}\n", .{result});
}

fn count_paths(succ: AdjList) !usize {
    const topo = try topo_sort(succ);

    // count
    var paths = std.AutoHashMap(Ident, usize).init(std.heap.page_allocator);
    try paths.put("you".*, 1);
    for (topo.items) |node| {
        if (paths.get(node)) |node_paths| {
            if (succ.get(node)) |succs| {
                for (succs.items) |node_succ| {
                    var succ_paths = try paths.getOrPutValue(node_succ, 0);
                    succ_paths.value_ptr.* += node_paths;
                }
            }
        }
    }
    return paths.get("out".*).?;
}

fn topo_sort(succ: AdjList) !std.ArrayList(Ident) {
    // collect in degrees of nodes
    var in_degree = std.AutoHashMap(Ident, usize).init(std.heap.page_allocator);
    var succ_it = succ.iterator();
    while (succ_it.next()) |entry| {
        _ = try in_degree.getOrPutValue(entry.key_ptr.*, 0);
        for (entry.value_ptr.items) |item| {
            var deg = try in_degree.getOrPutValue(item, 0);
            deg.value_ptr.* += 1;
        }
    }

    // topo sort
    var topo_order = try std.ArrayList(Ident).initCapacity(std.heap.page_allocator, succ.count());
    var queue = try std.Deque(Ident).initCapacity(std.heap.page_allocator, succ.count());

    var in_it = in_degree.iterator();
    while (in_it.next()) |entry| {
        if (entry.value_ptr.* == 0) {
            queue.pushBackAssumeCapacity(entry.key_ptr.*);
        }
    }

    while (queue.popFront()) |this| {
        try topo_order.append(std.heap.page_allocator, this);
        if (succ.get(this)) |succs| {
            for (succs.items) |this_succ| {
                const this_succ_indegree = in_degree.getPtr(this_succ).?;
                this_succ_indegree.* -= 1;
                if (this_succ_indegree.* == 0) {
                    queue.pushBackAssumeCapacity(this_succ);
                }
            }
        }
    }
    return topo_order;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
