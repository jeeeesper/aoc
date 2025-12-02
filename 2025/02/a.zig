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

fn is_invalid(num: usize) !bool {
    const powerOfTen: usize = @intFromFloat(@ceil(std.math.log10(@as(f64, @floatFromInt(num)))));
    if (powerOfTen % 2 != 0) {
        return false;
    }
    const denom = try std.math.powi(usize, 10, powerOfTen / 2);
    const first_part = num / denom;
    const second_part = num % denom;
    if (first_part == second_part) {
        return true;
    }
    return false;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
