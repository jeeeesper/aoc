const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

const Interval = struct { lower: u64, upper: u64 };

pub fn main() !void {
    // read input
    var intervals = try std.ArrayList(Interval).initCapacity(std.heap.page_allocator, 0);
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            break;
        }
        if (std.mem.findScalar(u8, line, '-')) |dash_pos| {
            const left_num = try std.fmt.parseInt(u64, line[0..dash_pos], 10);
            const right_num = try std.fmt.parseInt(u64, line[(dash_pos + 1)..], 10);
            try intervals.append(std.heap.page_allocator, .{ .lower = left_num, .upper = right_num });
        }
    }

    // empty line is skipped by call in while condition

    var fresh_ingredients: usize = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        const num = try std.fmt.parseInt(u64, line, 10);
        for (intervals.items) |interval| {
            if (num >= interval.lower and num <= interval.upper) {
                fresh_ingredients += 1;
                break;
            }
        }
    }

    try print("{d}\n", .{fresh_ingredients});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
