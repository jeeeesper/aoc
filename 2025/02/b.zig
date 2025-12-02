const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var result_sum: usize = 0;
    while (try stdin.takeDelimiter(',')) |interval| {
        const trimmed = std.mem.trim(u8, interval, " \n");
        if (std.mem.findScalar(u8, trimmed, '-')) |comma_pos| {
            const left_num = try std.fmt.parseInt(usize, trimmed[0..comma_pos], 10);
            const right_num = try std.fmt.parseInt(usize, trimmed[(comma_pos + 1)..], 10);
            for (left_num..right_num + 1) |num| {
                if (try is_invalid(num)) {
                    result_sum += num;
                }
            }
        }
    }
    try print("{d}\n", .{result_sum});
}

var buf: [1024]u8 = undefined;

fn is_invalid(num: usize) !bool {
    const len = std.fmt.printInt(&buf, num, 10, .lower, .{});
    const num_str = buf[0..len];
    for (1..len / 2 + 1) |rep_len| {
        if (len % rep_len != 0) {
            continue;
        }
        var is_repeating = true;
        const baseline = num_str[0..rep_len];
        for (1..(len / rep_len)) |i| {
            const to_compare = num_str[i * rep_len .. (i + 1) * rep_len];
            is_repeating &= std.mem.eql(u8, to_compare, baseline);
        }
        if (is_repeating) {
            return true;
        }
    }
    return false;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
