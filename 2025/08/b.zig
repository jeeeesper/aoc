const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

const Point = [3]i32;

pub fn main() !void {
    var points = std.ArrayList(Point).empty;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        var point: Point = undefined;
        var coords = std.mem.splitScalar(u8, line, ',');
        for (0..3) |ix| {
            const num_str = coords.next().?;
            const num = try std.fmt.parseInt(i32, num_str, 10);
            point[ix] = num;
        }
        try points.append(std.heap.page_allocator, point);
    }

    const cps = try naive_closest_pairs(&points);
    var forest = try make_forest(points.items.len);
    for (cps.items) |pair| {
        const new_size = combine(forest.items, pair[0], pair[1]);
        if (new_size == points.items.len) {
            const px = @as(i64, points.items[pair[0]][0]);
            const qx = @as(i64, points.items[pair[1]][0]);
            try print("{d}\n", .{px * qx});
            return;
        }
    }
}

fn naive_closest_pairs(points: *std.ArrayList(Point)) !std.ArrayList([2]usize) {
    var pairs = try std.ArrayList([2]usize).initCapacity(std.heap.page_allocator, points.items.len * (points.items.len - 1) / 2);
    for (0..points.items.len) |i| {
        for ((i + 1)..points.items.len) |j| {
            pairs.appendAssumeCapacity(.{ i, j });
        }
    }
    std.mem.sort([2]usize, pairs.items, points, pointDistLessThan);
    return pairs;
}

fn pointDistLessThan(points: *std.ArrayList(Point), a: [2]usize, b: [2]usize) bool {
    const p = points.items[a[0]];
    const q = points.items[a[1]];
    const d1 = sqr_dist(p, q);
    const r = points.items[b[0]];
    const s = points.items[b[1]];
    const d2 = sqr_dist(r, s);
    return d1 < d2;
}

fn sqr_dist(p: Point, q: Point) f32 {
    var d: [3]f32 = undefined;
    for (0..3) |dim| {
        d[dim] = @floatFromInt(q[dim] - p[dim]);
    }
    return d[0] * d[0] + d[1] * d[1] + d[2] * d[2];
}

const Data = struct {
    self: usize,
    parent: usize,
    size: usize,
};

fn make_forest(n: usize) !std.ArrayList(Data) {
    var ccs = try std.ArrayList(Data).initCapacity(std.heap.page_allocator, n);
    for (0..n) |i| {
        ccs.appendAssumeCapacity(.{
            .self = i,
            .parent = i,
            .size = 1,
        });
    }
    return ccs;
}

fn find(forest: []Data, x: usize) usize {
    if (forest[x].parent != x) {
        forest[x].parent = find(forest, forest[x].parent);
        return forest[x].parent;
    } else {
        return x;
    }
}

fn combine(forest: []Data, x: usize, y: usize) usize {
    const rx = find(forest, x);
    const ry = find(forest, y);

    if (rx == ry) {
        return forest[rx].size;
    }

    if (forest[rx].size < forest[ry].size) {
        forest[rx].parent = ry;
        forest[ry].size += forest[rx].size;
        return forest[ry].size;
    } else {
        forest[ry].parent = rx;
        forest[rx].size += forest[ry].size;
        return forest[rx].size;
    }
}

fn largeSetsFirst(ctx: @TypeOf(.{}), a: Data, b: Data) bool {
    _ = ctx;
    if (a.self == a.parent) {
        if (b.self == b.parent) {
            return a.size > b.size;
        }
        return true;
    }
    return false;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
