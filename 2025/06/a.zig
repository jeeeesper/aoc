const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var columns = try std.ArrayList(std.ArrayList(u64)).initCapacity(std.heap.page_allocator, 0);
    var first_line = true;
    var total_sum: u64 = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            break;
        }
        var index: usize = 0;
        var it = std.mem.tokenizeScalar(u8, line, ' ');
        while (it.next()) |num| {
            if (num.len == 0) {
                continue;
            }
            if (first_line) {
                try columns.append(std.heap.page_allocator, try std.ArrayList(u64).initCapacity(std.heap.page_allocator, 0));
            }
            if (num[0] == '+') {
                var res: u64 = 0;
                for (columns.items[index].items) |item| {
                    res += item;
                }
                total_sum += res;
            } else if (num[0] == '*') {
                var res: u64 = 1;
                for (columns.items[index].items) |item| {
                    res *= item;
                }
                total_sum += res;
            } else {
                const parsed_num = try std.fmt.parseInt(u64, num, 10);
                try columns.items[index].append(std.heap.page_allocator, parsed_num);
            }
            index += 1;
        }
        first_line = false;
    }

    try print("{d}\n", .{total_sum});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
