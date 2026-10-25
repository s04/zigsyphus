const std = @import("std");

pub const RecognitionError = error{
    InvalidRowCount,
    InvalidColumnCount,
};

const digit_patterns = [_][]const u8{
    " _ | ||_|   ", // 0
    "     |  |   ", // 1
    " _  _||_    ", // 2
    " _  _| _|   ", // 3
    "   |_|  |   ", // 4
    " _ |_  _|   ", // 5
    " _ |_ |_|   ", // 6
    " _   |  |   ", // 7
    " _ |_||_|   ", // 8
    " _ |_| _|   ", // 9
};

pub fn convert(buffer: []u8, input: []const []const u8) RecognitionError![]u8 {
    const row_count = input.len;
    if (row_count % 4 != 0) {
        return RecognitionError.InvalidRowCount;
    }

    if (row_count == 0) {
        return "";
    }

    const col_count = input[0].len;
    for (input) |row| {
        if (row.len != col_count) {
            return RecognitionError.InvalidColumnCount;
        }
    }

    if (col_count % 3 != 0) {
        return RecognitionError.InvalidColumnCount;
    }

    const digits_per_row = col_count / 3;
    const row_groups = row_count / 4;

    var writer = std.io.fixedBufferStream(&buffer).writer();
    var first_row = true;

    for (0..row_groups) |row_group| {
        if (!first_row) {
            try writer.writeByte(',');
        }
        first_row = false;

        for (0..digits_per_row) |digit_idx| {
            var pattern: [12]u8 = undefined;
            var pattern_idx: usize = 0;

            for (0..4) |row_offset| {
                const row = input[row_group * 4 + row_offset];
                const start_col = digit_idx * 3;
                for (0..3) |col_offset| {
                    pattern[pattern_idx] = row[start_col + col_offset];
                    pattern_idx += 1;
                }
            }

            var found = false;
            for (digit_patterns, 0..) |known_pattern, digit| {
                if (std.mem.eql(u8, &pattern, known_pattern)) {
                    try writer.writeByte(@as(u8, @intCast(digit + '0')));
                    found = true;
                    break;
                }
            }

            if (!found) {
                try writer.writeByte('?');
            }
        }
    }

    return writer.bytesWritten();
}
