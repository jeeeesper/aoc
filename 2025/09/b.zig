const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var points = std.ArrayList([2]i64).empty;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        const comma_ix = std.mem.findScalar(u8, line, ',').?;
        const x = try std.fmt.parseInt(i64, line[0..comma_ix], 10);
        const y = try std.fmt.parseInt(i64, line[comma_ix + 1 ..], 10);
        try points.append(std.heap.page_allocator, .{ x, y });
    }

    var line_segments = try std.ArrayList([2][2]i64).initCapacity(std.heap.page_allocator, points.items.len);
    for (0..points.items.len) |ix| {
        line_segments.appendAssumeCapacity(.{ points.items[ix], points.items[@mod(ix + 1, points.items.len)] });
    }

    var rectangles = try std.ArrayList(Rectangle).initCapacity(std.heap.page_allocator, points.items.len * (points.items.len - 1) / 2);
    for (0..points.items.len) |i| {
        for (i + 1..points.items.len) |j| {
            const a = area(points.items[i], points.items[j]);
            rectangles.appendAssumeCapacity(.{ .endpoints = .{ i, j }, .area = a });
        }
    }

    std.mem.sort(Rectangle, rectangles.items, {}, compareArea);

    // TODO this is brute force, and also fails in the case that there is a large "outside" rectangle
    for (rectangles.items) |r| {
        var intersects = false;
        for (line_segments.items) |seg| {
            if (line_intersects_rect(seg, r.endpoints, points.items)) {
                intersects = true;
                break;
            }
        }
        if (!intersects) {
            try print("{d}\n", .{r.area});
            return;
        }
    }
}

const Rectangle = struct {
    endpoints: [2]usize,
    area: u64,
};

fn compareArea(ctx: void, a: Rectangle, b: Rectangle) bool {
    _ = ctx;
    return a.area > b.area;
}

fn area(a: [2]i64, b: [2]i64) u64 {
    const dx = @abs(a[0] - b[0]) + 1;
    const dy = @abs(a[1] - b[1]) + 1;
    return dx * dy;
}

fn line_intersects_rect(line: [2][2]i64, rect: [2]usize, points: [][2]i64) bool {
    const min_x = @min(line[0][0], line[1][0]);
    const min_y = @min(line[0][1], line[1][1]);
    const max_x = @max(line[0][0], line[1][0]);
    const max_y = @max(line[0][1], line[1][1]);
    var x = min_x;
    while (x <= max_x) {
        var y = min_y;
        while (y <= max_y) {
            if (point_in_rect(.{ x, y }, .{ points[rect[0]], points[rect[1]] })) {
                return true;
            }
            y += 1;
        }
        x += 1;
    }
    return false;
}

fn point_in_rect(point: [2]i64, rect: [2][2]i64) bool {
    var inside = true;
    for (0..2) |dim| {
        const min = @min(rect[0][dim], rect[1][dim]);
        const max = @max(rect[0][dim], rect[1][dim]);
        inside = inside and point[dim] > min and point[dim] < max;
    }
    return inside;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
