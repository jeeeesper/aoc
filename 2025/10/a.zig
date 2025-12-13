const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var result: usize = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        var buttons = std.ArrayList(u16).empty;
        var target: u16 = undefined;
        var it = std.mem.tokenizeScalar(u8, line, ' ');
        while (it.next()) |tok| {
            if (tok[0] == '[') {
                var buf: [16]u8 = undefined;
                var bits = buf[0 .. tok.len - 2];
                std.mem.copyForwards(u8, bits, tok[1 .. tok.len - 1]);
                for (0..bits.len) |ix| {
                    if (bits[ix] == '#') {
                        bits[ix] = '1';
                    } else {
                        bits[ix] = '0';
                    }
                }
                std.mem.reverse(u8, bits);
                target = try std.fmt.parseInt(u16, bits, 2);
            } else if (tok[0] == '(') {
                var nums_it = std.mem.tokenizeScalar(u8, tok[1 .. tok.len - 1], ',');
                var button: u16 = 0;
                while (nums_it.next()) |num_str| {
                    const num = try std.fmt.parseInt(usize, num_str, 10);
                    button |= @as(u16, 1) << @truncate(num);
                }
                try buttons.append(std.heap.page_allocator, button);
            }
        }
        const this_result = solve(target, buttons.items);
        result += this_result.?;
    }

    try print("{d}\n", .{result});
}

fn solve(target: u16, buttons: []u16) ?usize {
    var best: u8 = 17;
    const num_combinations = @as(u16, 1) << @truncate(buttons.len);
    for (0..num_combinations) |combination| {
        const ones = count_ones(@truncate(combination));
        if (best <= ones) {
            continue;
        }
        var result_state: u16 = 0;
        for (buttons, 0..) |button, ix| {
            if (combination & (@as(u16, 1) << @truncate(ix)) != 0) {
                result_state ^= button;
            }
        }
        if (result_state == target) {
            best = ones;
        }
    }
    if (best < 17) {
        return @as(usize, best);
    } else {
        return null;
    }
}

fn count_ones(num: u16) u8 {
    var ones: u8 = 0;
    var tmp = num;
    while (tmp != 0) {
        ones += 1;
        tmp &= tmp - 1;
    }
    return ones;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
