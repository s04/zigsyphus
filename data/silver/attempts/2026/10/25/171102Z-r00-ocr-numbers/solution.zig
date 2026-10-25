const std = @import("std");

pub const RecognitionError = error{
    InvalidRowCount,
    InvalidColumnCount,
};

// Patterns for digits 0-9, each as 4 lines of 3 chars
const patterns = [_][]const u8{
    // 0
    " _ ",
    "| |",
    "|_|",
    "   ",
    // 1
    "   ",
    "  |",
    "  |",
    "   ",
    // 2
    " _ ",
    " _|",
    "|_ ",
    "   ",
    // 3
    " _ ",
    " _|",
    " _|",
    "   ",
    // 4
    "   ",
    "|_|",
    "  |",
    "   ",
    // 5
    " _ ",
    "|_ ",
    " _|",
    "   ",
    // 6
    " _ ",
    "|_ ",
    "|_|",
    "   ",
    // 7
    " _ ",
    "  |",
    "  |",
    "   ",
    // 8
    " _ ",
    "|_|",
    "|_|",
    "   ",
    // 9
    " _ ",
    "|_|",
    " _|",
    "   ",
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
    if (col_count % 3 != 0) {
        return RecognitionError.InvalidColumnCount;
    }

    // Verify all rows have same length
    for (input) |line| {
        if (line.len != col_count) {
            return RecognitionError.InvalidColumnCount;
        }
    }

    const digits_per_row = col_count / 3;
    const row_groups = row_count / 4;

    var output_pos: usize = 0;

    for (0..row_groups) |row_group| {
        const base_row = row_group * 4;

        for (0..digits_per_row) |digit_idx| {
            const base_col = digit_idx * 3;

            // Extract 3x4 cell
            var cell: [4][]const u8 = undefined;
            for (0..4) |r| {
                cell[r] = input[base_row + r][base_col .. base_col + 3];
            }

            // Match against patterns
            var found = false;
            for (0..10) |digit| {
                var matches = true;
                for (0..4) |r| {
                    if (!std.mem.eql(u8, cell[r], patterns[digit * 4 + r])) {
                        matches = false;
                        break;
                    }
                }
                if (matches) {
                    if (output_pos < buffer.len) {
                        buffer[output_pos] = '0' + digit;
                        output_pos += 1;
                    }
                    found = true;
                    break;
                }
            }

            if (!found) {
                if (output_pos < buffer.len) {
                    buffer[output_pos] = '?';
                    output_pos += 1;
                }
            }
        }

        // Add comma between rows (except after last row)
        if (row_group != row_groups - 1) {
            if (output_pos < buffer.len) {
                buffer[output_pos] = ',';
                output_pos += 1;
            }
        }
    }

    return buffer[0..output_pos];
}
