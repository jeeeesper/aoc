const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

const NUM_DIGITS = 12;

pub fn main() !void {
    var result_sum: usize = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        var start_index: usize = 0;
        for (0..NUM_DIGITS) |i| {
            const this_index = std.mem.findMax(u8, line[start_index .. line.len - NUM_DIGITS + i + 1]) + start_index;
            start_index = this_index + 1;
            result_sum += try std.math.powi(usize, 10, NUM_DIGITS - i - 1) * (line[this_index] - '0');
        }
    }
    try print("{d}\n", .{result_sum});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
