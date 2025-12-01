const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var pos: i32 = 50;
    var zero_counter: u32 = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        const num = try std.fmt.parseInt(i32, line[1..], 10);
        pos = if (line[0] == 'L') pos - num else pos + num;
        pos = @mod(pos, 100);
        if (pos == 0) {
            zero_counter += 1;
        }
    }
    try print("{d}\n", .{zero_counter});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
