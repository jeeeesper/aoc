const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var result_sum: usize = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        const first_ix = std.mem.findMax(u8, line[0 .. line.len - 1]);
        const second_ix = std.mem.findMax(u8, line[first_ix + 1 ..]) + first_ix + 1;
        const result = (line[first_ix] - '0') * 10 + line[second_ix] - '0';
        result_sum += result;
    }
    try print("{d}\n", .{result_sum});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
