const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var pos: i32 = 50;
    var zero_counter: i32 = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        var num = try std.fmt.parseInt(i32, line[1..], 10);

        // first, get num to 0-99 space
        zero_counter += @divTrunc(num, 100);
        num = @mod(num, 100);

        // no change in pos
        if (num == 0) {
            continue;
        }

        const next = if (line[0] == 'L') pos - num else pos + num;

        // wrap around (but only if not e.g. 0->96 (zero has been counted before))
        if ((next <= 0 or next >= 100) and pos != 0) {
            zero_counter += 1;
        }

        pos = @mod(next, 100);
    }
    try print("{d}\n", .{zero_counter});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
