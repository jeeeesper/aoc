const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var total_splits: u64 = 0;
    const start_line = (try stdin.takeDelimiter('\n')).?;
    const s = std.mem.findScalar(u8, start_line, 'S').?;
    const len = start_line.len;
    var beams = try std.DynamicBitSet.initEmpty(std.heap.page_allocator, len);
    beams.set(s);
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        var new_beams =
            try std.DynamicBitSet.initEmpty(std.heap.page_allocator, start_line.len);
        for (0..len) |ix| {
            if (line[ix] == '^' and beams.isSet(ix)) {
                new_beams.set(ix - 1);
                new_beams.set(ix + 1);
                total_splits += 1;
            } else if (beams.isSet(ix)) {
                new_beams.set(ix);
            }
        }
        beams = new_beams;
    }

    try print("{d}\n", .{total_splits});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
