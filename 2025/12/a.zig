const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [4096]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

const Shape = struct {
    points: std.ArrayList([2]usize),
    len_x: usize,
    len_y: usize,
};

pub fn main() !void {
    var result: usize = 0;
    var shapes = std.ArrayList([8]?Shape).empty;
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        if (line[line.len - 1] == ':') {
            // parse the next few lines as a shape, until there is an empty line
            var points = std.ArrayList([2]usize).empty;
            var len_x: usize = 0;
            var len_y: usize = 0;
            var i: u8 = 0;
            while (try stdin.takeDelimiter('\n')) |shape_line| {
                if (shape_line.len == 0) {
                    break;
                }
                for (shape_line, 0..) |shape_char, j| {
                    if (shape_char == '#') {
                        if (i >= len_x) {
                            len_x = i + 1;
                        }
                        if (j >= len_y) {
                            len_y = j + 1;
                        }
                        try points.append(std.heap.page_allocator, .{ i, j });
                    }
                }
                i += 1;
            }
            const shape: Shape =
                .{
                    .len_x = len_x,
                    .len_y = len_y,
                    .points = points,
                };
            try shapes.append(std.heap.page_allocator, try rotations_and_flips(shape));
        } else {
            // parse field and piece configuration
            const x_pos = std.mem.findScalar(u8, line, 'x').?;
            const colon_pos = std.mem.findScalar(u8, line, ':').?;
            const dim1 = try std.fmt.parseInt(usize, line[0..x_pos], 10);
            const dim2 = try std.fmt.parseInt(usize, line[x_pos + 1 .. colon_pos], 10);

            var pieces = std.ArrayList([8]?Shape).empty;
            var shape_num_it = std.mem.tokenizeScalar(u8, line[colon_pos + 1 ..], ' ');
            var shape_ix: usize = 0;
            while (shape_num_it.next()) |piece_num| {
                const num = try std.fmt.parseInt(usize, piece_num, 10);
                try pieces.appendNTimes(std.heap.page_allocator, shapes.items[shape_ix], num);
                shape_ix += 1;
            }

            // solve
            var board = try std.ArrayList(bool).initCapacity(std.heap.page_allocator, dim1 * dim2);
            board.appendNTimesAssumeCapacity(false, dim1 * dim2);
            if (board_big_enough(board.items.len, pieces.items)) {
                const fits = try can_fit(board.items, dim1, dim2, pieces.items);
                if (fits) {
                    result += 1;
                }
            }
        }
    }

    try print("{d}\n", .{result});
}

fn board_big_enough(board_len: usize, pieces: [][8]?Shape) bool {
    var piece_sum: usize = 0;
    for (pieces) |rotations| {
        // first rotation is always present
        piece_sum += rotations[0].?.points.items.len;
    }
    return board_len >= piece_sum;
}

fn can_fit(board: []bool, board_len_x: usize, board_len_y: usize, pieces: [][8]?Shape) !bool {
    if (pieces.len == 0) {
        return true;
    }
    for (pieces[0]) |maybe_piece| {
        if (maybe_piece) |piece| {
            for (0..board_len_x - piece.len_x + 1) |i| {
                for (0..board_len_y - piece.len_y + 1) |j| {
                    // try to fit this specific rotation at this specific place on the board
                    var fits_here = true;
                    for (piece.points.items) |point| {
                        const coord_x = i + point[0];
                        const coord_y = j + point[1];
                        fits_here &= !(board[coord_y * board_len_x + coord_x]);
                    }
                    if (fits_here) {
                        // actually place it
                        for (piece.points.items) |point| {
                            const coord_x = i + point[0];
                            const coord_y = j + point[1];
                            board[coord_y * board_len_x + coord_x] = true;
                        }
                        // check if the rest can fit
                        const recurse_result = try can_fit(board, board_len_x, board_len_y, pieces[1..]);
                        if (recurse_result) {
                            // if yes, we're done
                            return true;
                        }
                        // unplace it, continue to search
                        for (piece.points.items) |point| {
                            const coord_x = i + point[0];
                            const coord_y = j + point[1];
                            board[coord_y * board_len_x + coord_x] = false;
                        }
                    }
                }
            }
        }
    }
    return false;
}

fn rotations_and_flips(orig_shape: Shape) ![8]?Shape {
    var working_copy = orig_shape;
    var result: [8]?Shape = undefined;
    for (0..2) |i| {
        for (0..4) |j| {
            result[4 * i + j] = working_copy;

            // rotate by 90 cw
            working_copy = .{ .len_x = working_copy.len_y, .len_y = working_copy.len_x, .points = try working_copy.points.clone(std.heap.page_allocator) };
            for (0..working_copy.points.items.len) |ix| {
                const old_x = working_copy.points.items[ix][0];
                working_copy.points.items[ix][0] = working_copy.points.items[ix][1];
                working_copy.points.items[ix][1] = working_copy.len_y - old_x - 1;
            }
        }
        // flip
        for (0..working_copy.points.items.len) |ix| {
            working_copy.points.items[ix][0] = working_copy.len_x - working_copy.points.items[ix][0] - 1;
        }
    }

    // dedup
    for (1..8) |this| {
        const this_shape = result[this].?;
        for (0..this) |prev| {
            if (result[prev]) |prev_shape| {
                if (this_shape.len_x == prev_shape.len_x and this_shape.len_y == prev_shape.len_y) {
                    var all_contained = true;
                    for (this_shape.points.items) |this_point| {
                        var found = false;
                        for (prev_shape.points.items) |prev_point| {
                            if (this_point[0] == prev_point[0] and this_point[1] == prev_point[1]) {
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            all_contained = false;
                            break;
                        }
                    }

                    if (all_contained) {
                        // this is a duplicate, remove
                        result[this] = null;
                    }
                }
            }
        }
    }
    return result;
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    const str =
        try std.fmt.allocPrint(std.heap.page_allocator, fmt, args);
    const out = std.fs.File.stdout();
    try out.writeAll(str);
}
