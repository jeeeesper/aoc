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

    var max_area: u64 = 0;
    for (0..points.items.len) |i| {
        for (i + 1..points.items.len) |j| {
            const a = area(points.items[i], points.items[j]);
            if (a > max_area) {
                max_area = a;
            }
        }
    }

    try print("{d}\n", .{max_area});
}

fn area(a: [2]i64, b: [2]i64) u64 {
    const dx = @abs(a[0] - b[0]) + 1;
    const dy = @abs(a[1] - b[1]) + 1;
    return dx * dy;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
