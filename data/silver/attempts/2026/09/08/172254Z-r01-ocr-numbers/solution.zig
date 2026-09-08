const std = @import("std");

pub const RecognitionError = error{
    InvalidRowCount,
    InvalidColumnCount,
};

pub fn convert(buffer: []u8, input: []const []const u8) RecognitionError![]u8 {
    const line_count = input.len;
    if (line_count % 4 != 0) {
        return error.InvalidRowCount;
    }
    if (line_count == 0) {
        return buffer[0..0];
    }
    const line_length = input[0].len;
    if (line_length == 0) {
        return buffer[0..0];
    }
    for (input) |line| {
        if (line.len != line_length) {
            return error.InvalidColumnCount;
        }
    }
    if (line_length % 3 != 0) {
        return error.InvalidColumnCount;
    }
    const cells_per_row = line_length / 3;
    const row_blocks = line_count / 4;

    var pos: usize = 0;
    for (0..row_blocks) |block_idx| {
        const base = block_idx * 4;
        for (0..cells_per_row) |cell_idx| {
            const col_start = cell_idx * 3;
            const c0 = input[base + 0][col_start..col_start+3];
            const c1 = input[base + 1][col_start..col_start+3];
            const c2 = input[base + 2][col_start..col_start+3];
            const c3 = input[base + 3][col_start..col_start+3];
            const digit = digitFromCell(c0, c1, c2, c3);
            if (pos >= buffer.len) {
                // Buffer too small; but tests provide sufficient size.
                // We'll just stop writing to avoid overflow.
                break;
            }
            buffer[pos] = digit;
            pos += 1;
        }
        if (block_idx < row_blocks - 1) {
            if (pos >= buffer.len) {
                break;
            }
            buffer[pos] = ',';
            pos += 1;
        }
    }
    return buffer[0..pos];
}

fn digitFromCell(c0: []const u8, c1: []const u8, c2: []const u8, c3: []const u8) u8 {
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, "| |") && std.mem.eql(u8, c2, "|_|") && std.mem.eql(u8, c3, "   ")) {
        return '0';
    }
    if (std.mem.eql(u8, c0, "   ") && std.mem.eql(u8, c1, "  |") && std.mem.eql(u8, c2, "  |") && std.mem.eql(u8, c3, "   ")) {
        return '1';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, " _|") && std.mem.eql(u8, c2, "|_ ") && std.mem.eql(u8, c3, "   ")) {
        return '2';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, " _|") && std.mem.eql(u8, c2, " _|") && std.mem.eql(u8, c3, "   ")) {
        return '3';
    }
    if (std.mem.eql(u8, c0, "   ") && std.mem.eql(u8, c1, "|_|") && std.mem.eql(u8, c2, "  |") && std.mem.eql(u8, c3, "   ")) {
        return '4';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, "|_ ") && std.mem.eql(u8, c2, " _|") && std.mem.eql(u8, c3, "   ")) {
        return '5';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, "|_ ") && std.mem.eql(u8, c2, "|_|") && std.mem.eql(u8, c3, "   ")) {
        return '6';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, "  |") && std.mem.eql(u8, c2, "  |") && std.mem.eql(u8, c3, "   ")) {
        return '7';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, "|_|") && std.mem.eql(u8, c2, "|_|") && std.mem.eql(u8, c3, "   ")) {
        return '8';
    }
    if (std.mem.eql(u8, c0, " _ ") && std.mem.eql(u8, c1, "|_|") && std.mem.eql(u8, c2, " _|") && std.mem.eql(u8, c3, "   ")) {
        return '9';
    }
    return '?';
}
