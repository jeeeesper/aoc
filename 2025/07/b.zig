const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    const start_line = (try stdin.takeDelimiter('\n')).?;
    const s = std.mem.findScalar(u8, start_line, 'S').?;
    const len = start_line.len;
    var beams = try std.ArrayList(u64).initCapacity(std.heap.page_allocator, len);
    try beams.appendNTimes(std.heap.page_allocator, 0, len);
    beams.items[s] = 1;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        var new_beams = try std.ArrayList(u64).initCapacity(std.heap.page_allocator, len);
        try new_beams.appendNTimes(std.heap.page_allocator, 0, len);
        for (0..len) |ix| {
            const num_beams = beams.items[ix];
            if (line[ix] == '^') {
                new_beams.items[ix - 1] += num_beams;
                new_beams.items[ix + 1] += num_beams;
            } else {
                new_beams.items[ix] += num_beams;
            }
        }
        beams = new_beams;
    }

    var total_timelines: u64 = 0;
    for (beams.items) |pos| {
        total_timelines += pos;
    }

    try print("{d}\n", .{total_timelines});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
