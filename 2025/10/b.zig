const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

const Button = std.bit_set.IntegerBitSet(16);

pub fn main() !void {
    var result: usize = 0;
    var count: usize = 0;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        var buttons = std.ArrayList(Button).empty;
        var target: []u16 = undefined;
        var it = std.mem.tokenizeScalar(u8, line, ' ');
        while (it.next()) |tok| {
            if (tok[0] == '{') {
                var nums_it = std.mem.tokenizeScalar(u8, tok[1 .. tok.len - 1], ',');
                var buf: [16]u16 = undefined;
                var ix: usize = 0;
                while (nums_it.next()) |num| {
                    const parsed = try std.fmt.parseInt(u16, num, 10);
                    buf[ix] = parsed;
                    ix += 1;
                }
                target = buf[0..ix];
            } else if (tok[0] == '(') {
                var nums_it = std.mem.tokenizeScalar(u8, tok[1 .. tok.len - 1], ',');
                var button =
                    std.StaticBitSet(16).initEmpty();
                while (nums_it.next()) |num| {
                    const index = try std.fmt.parseInt(usize, num, 10);
                    button.set(index);
                }
                try buttons.append(std.heap.page_allocator, button);
            }
        }

        const this_result = try solve(target, buttons.items);
        result += this_result.?;
        std.log.info("solved {d}", .{count});
        count += 1;
    }

    try print("{d}\n", .{result});
}

fn solve(state: []u16, buttons: []Button) !?usize {
    if (std.mem.allEqual(u16, state, 0)) {
        // solved!
        return 0;
    }
    var best: ?usize = null;
    c: for (0..try std.math.powi(usize, 2, buttons.len)) |combination| {
        // apply all selected buttons and create new_state
        var new_state: [16]u16 = undefined;
        std.mem.copyForwards(u16, &new_state, state);
        for (buttons, 0..) |button, ix| {
            if (combination & try std.math.powi(usize, 2, ix) != 0) {
                var indices = button.iterator(.{});
                while (indices.next()) |index| {
                    if (new_state[index] == 0) {
                        continue :c;
                    }
                    new_state[index] -= 1;
                }
            }
        }
        var allEven = true;
        for (new_state[0..state.len]) |num| {
            if (num % 2 != 0) {
                allEven = false;
                break;
            }
        }
        if (allEven) {
            const pressed_this_round = count_ones(@truncate(combination));
            for (0..state.len) |ix| {
                new_state[ix] /= 2;
            }
            const result = try solve(new_state[0..state.len], buttons);
            if (result) |res| {
                const this = 2 * res + pressed_this_round;
                if (best == null or this < best.?) {
                    best = this;
                }
            }
        }
    }
    return best;
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

fn printState(state: []u16) !void {
    for (state) |num| {
        try print("{d}, ", .{num});
    }
    try print("\n", .{});
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
