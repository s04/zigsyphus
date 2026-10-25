const std = @import("std");

pub const RecognitionError = error{
    InvalidRowCount,
    InvalidColumnCount,
};

const Digit = struct {
    ch: u8,
    pattern: [3][3]u8,
};

const digits = [_]Digit{
    Digit{ .ch = '0', .pattern = {{' ', '_', ' '}, {'|', ' ', '|'}, {'|', '_', '|'}} },
    Digit{ .ch = '1', .pattern = {{' ', ' ', ' '}, {' ', ' ', '|'}, {' ', ' ', '|'}} },
    Digit{ .ch = '2', .pattern = {{' ', '_', ' '}, {' ', '_', '|'}, {'|', '_', ' '}} },
    Digit{ .ch = '3', .pattern = {{' ', '_', ' '}, {' ', '_', '|'}, {' ', '_', '|'}} },
    Digit{ .ch = '4', .pattern = {{' ', ' ', ' '}, {'|', '_', '|'}, {' ', ' ', '|'}} },
    Digit{ .ch = '5', .pattern = {{' ', '_', ' '}, {'|', '_', ' '}, {' ', '_', '|'}} },
    Digit{ .ch = '6', .pattern = {{' ', '_', ' '}, {'|', '_', ' '}, {'|', '_', '|'}} },
    Digit{ .ch = '7', .pattern = {{' ', '_', ' '}, {' ', ' ', '|'}, {' ', ' ', '|'}} },
    Digit{ .ch = '8', .pattern = {{' ', '_', ' '}, {'|', '_', '|'}, {'|', '_', '|'}} },
    Digit{ .ch = '9', .pattern = {{' ', '_', ' '}, {'|', '_', '|'}, {' ', '_', '|'}} },
};

fn patternsEqual(a: [3][3]u8, b: [3][3]u8) bool {
    for (0..3) |r| {
        for (0..3) |c| {
            if (a[r][c] != b[r][c]) return false;
        }
    }
    return true;
}

fn recognizeCell(input: []const []const u8, row_start: usize, col_start: usize) u8 {
    var pattern: [3][3]u8 = undefined;
    for (0..3) |r| {
        for (0..3) |c| {
            pattern[r][c] = input[row_start + r][col_start + c];
        }
    }
    for (digits) |d| {
        if (patternsEqual(pattern, d.pattern)) {
            return d.ch;
        }
    }
    return '?';
}

pub fn convert(buffer: []u8, input: []const []const u8) RecognitionError![]u8 {
    if (input.len % 4 != 0) {
        return RecognitionError.InvalidRowCount;
    }
    if (input.len == 0) {
        return buffer[0..0];
    }
    if (input[0].len % 3 != 0) {
        return RecognitionError.InvalidColumnCount;
    }

    const num_groups = input.len / 4;
    const num_digits = input[0].len / 3;

    var pos: usize = 0;
    for (0..num_groups) |g| {
        if (g > 0) {
            if (pos < buffer.len) buffer[pos] = ',';
            pos += 1;
        }
        const row_start = g * 4;
        for (0..num_digits) |d| {
            const col_start = d * 3;
            const ch = recognizeCell(input, row_start, col_start);
            if (pos < buffer.len) buffer[pos] = ch;
            pos += 1;
        }
    }

    return buffer[0..pos];
}
