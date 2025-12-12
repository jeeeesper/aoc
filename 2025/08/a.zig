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

    var forest = try make_forest(points.items.len);
    for (naive_closest_pairs(&points, 1000)) |pair| {
        combine(forest.items, pair[0], pair[1]);
    }

    std.mem.sort(Data, forest.items, .{}, comptime largeSetsFirst);

    const result = forest.items[0].size * forest.items[1].size * forest.items[2].size;

    try print("{d}\n", .{result});
}

fn naive_closest_pairs(points: *std.ArrayList(Point), n: comptime_int) [n][2]usize {
    var result: [n][2]usize = undefined;
    var dists: [n]f32 = undefined;
    for (0..n) |ix| {
        dists[ix] = std.math.floatMax(f32);
    }
    for (0..points.items.len) |i| {
        const p = points.items[i];
        for ((i + 1)..points.items.len) |j| {
            const q = points.items[j];
            var d: [3]f32 = undefined;
            for (0..3) |dim| {
                d[dim] = @floatFromInt(p[dim] - q[dim]);
            }
            const dist = @sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
            if (dist <= dists[n - 1]) {
                dists[n - 1] = dist;
                result[n - 1] = .{ i, j };
                var k: usize = n - 1;
                while (k > 0 and dists[k - 1] > dists[k]) {
                    std.mem.swap(f32, &dists[k - 1], &dists[k]);
                    std.mem.swap([2]usize, &result[k - 1], &result[k]);
                    k -= 1;
                }
            }
        }
    }
    return result;
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

fn combine(forest: []Data, x: usize, y: usize) void {
    const rx = find(forest, x);
    const ry = find(forest, y);

    if (rx == ry) {
        return;
    }

    if (forest[rx].size < forest[ry].size) {
        forest[rx].parent = ry;
        forest[ry].size += forest[rx].size;
    } else {
        forest[ry].parent = rx;
        forest[rx].size += forest[ry].size;
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
