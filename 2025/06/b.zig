const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var lines = try std.ArrayList([]const u8).initCapacity(std.heap.page_allocator, 0);
    const input = try stdin.allocRemaining(std.heap.page_allocator, std.Io.Limit.unlimited);
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        try lines.append(std.heap.page_allocator, line);
    }
    var max_len: u64 = 0;
    for (lines.items) |line| {
        if (line.len > max_len) {
            max_len = line.len;
        }
    }
    const last_line = lines.items[lines.items.len - 1];
    var total_sum: u64 = 0;
    var numbers = try std.ArrayList(u64).initCapacity(std.heap.page_allocator, 0);
    for (0..max_len) |negative_index| {
        const index = max_len - negative_index - 1;
        // read number
        var number: ?u64 = null;
        for (0..lines.items.len - 1) |line_ix| {
            const char = lines.items[line_ix][index];
            if (char != ' ') {
                if (number == null) {
                    number = 0;
                }
                const digit = @as(u64, char - '0');
                number.? *= 10;
                number.? += digit;
            }
        }
        if (number != null) {
            try numbers.append(std.heap.page_allocator, number.?);
        }

        if (last_line.len > index and last_line[index] != ' ') {
            // compute and clear cache
            if (last_line[index] == '+') {
                var res: u64 = 0;
                for (numbers.items) |num| {
                    res += num;
                }
                total_sum += res;
            } else if (last_line[index] == '*') {
                var res: u64 = 1;
                for (numbers.items) |num| {
                    res *= num;
                }
                total_sum += res;
            }
            numbers.clearRetainingCapacity();
        }
    }

    try print("{d}\n", .{total_sum});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
