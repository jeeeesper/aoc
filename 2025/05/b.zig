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

    std.mem.sort(Interval, intervals.items, {}, cmpByLower);

    var max_upper: u64 = 0;
    var num_fresh_ingredients: u64 = 0;
    for (intervals.items) |interval| {
        const start = if (max_upper > interval.lower) max_upper else interval.lower;
        if (start > interval.upper) {
            continue;
        }
        num_fresh_ingredients += interval.upper - start + 1;
        max_upper = interval.upper + 1;
    }

    try print("{d}\n", .{num_fresh_ingredients});
}

fn cmpByLower(context: void, a: Interval, b: Interval) bool {
    return std.sort.asc(u64)(context, a.lower, b.lower);
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
