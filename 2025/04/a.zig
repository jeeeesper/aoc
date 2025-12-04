const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    // read input
    var map = try std.ArrayList(u8).initCapacity(std.heap.page_allocator, 0);
    var row_len: usize = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        row_len = line.len;
        try map.appendSlice(std.heap.page_allocator, line);
    }

    var accessible_rolls: usize = 0;
    for (0..map.items.len) |ix| {
        if (map.items[ix] != '@') {
            continue;
        }
        const row = ix / row_len;
        const col = ix % row_len;
        var count_surrounds: usize = 0;

        const left_edge = col == 0;
        const right_edge = col == row_len - 1;
        const top_edge = row == 0;
        const bottom_edge = row == (map.items.len / row_len) - 1;

        // top left
        if (!left_edge and !top_edge and map.items[ix - row_len - 1] == '@') {
            count_surrounds += 1;
        }
        // top
        if (!top_edge and map.items[ix - row_len] == '@') {
            count_surrounds += 1;
        }
        // top right
        if (!right_edge and !top_edge and map.items[ix - row_len + 1] == '@') {
            count_surrounds += 1;
        }
        // left
        if (!left_edge and map.items[ix - 1] == '@') {
            count_surrounds += 1;
        }
        // right
        if (!right_edge and map.items[ix + 1] == '@') {
            count_surrounds += 1;
        }
        // bottom left
        if (!left_edge and !bottom_edge and map.items[ix + row_len - 1] == '@') {
            count_surrounds += 1;
        }
        // bottom
        if (!bottom_edge and map.items[ix + row_len] == '@') {
            count_surrounds += 1;
        }
        // bottom right
        if (!right_edge and !bottom_edge and map.items[ix + row_len + 1] == '@') {
            count_surrounds += 1;
        }
        if (count_surrounds < 4) {
            accessible_rolls += 1;
        }
    }
    try print("{d}\n", .{accessible_rolls});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
