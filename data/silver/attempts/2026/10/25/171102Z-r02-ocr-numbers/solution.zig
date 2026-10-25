const std = @import("std");

pub const RecognitionError = error{
    InvalidRowCount,
    InvalidColumnCount,
};

pub fn convert(buffer: []u8, input: []const []const u8) RecognitionError![]u8 {
    // Check row count is multiple of 4
    if (input.len % 4 != 0) {
        return error.InvalidRowCount;
    }
    
    // Check column count is multiple of 3
    if (input.len > 0) {
        const col_count = input[0].len;
        if (col_count % 3 != 0) {
            return error.InvalidColumnCount;
        }
        // Verify all rows have same column count
        for (input) |row| {
            if (row.len != col_count) {
                return error.InvalidColumnCount;
            }
        }
    }
    
    // Digit patterns: 0-9
    const digit_patterns = [_][4][3]u8{
        " _ ".*,
        "| |".*,
        "|_|".*,
        "   ".*,
    };
    
    // Build result
    var result: []u8 = buffer;
    var result_idx: usize = 0;
    
    // Process each group of 4 rows
    var row_group: usize = 0;
    while (row_group < input.len) : (row_group += 4) {
        // Process each cell in the row
        var col: usize = 0;
        while (col < input[0].len) : (col += 3) {
            // Extract 3x4 cell
            var cell: [4][3]u8;
            var r: usize = 0;
            while (r < 4) : (r += 1) {
                var c: usize = 0;
                while (c < 3) : (c += 1) {
                    cell[r][c] = input[row_group + r][col + c];
                }
            }
            
            // Find matching digit
            var found: bool = false;
            var digit: u8 = '?';
            var d: usize = 0;
            while (d < 10) : (d += 1) {
                var match: bool = true;
                var rr: usize = 0;
                while (rr < 4) : (rr += 1) {
                    var cc: usize = 0;
                    while (cc < 3) : (cc += 1) {
                        if (cell[rr][cc] != digit_patterns[d][rr][cc]) {
                            match = false;
                            break;
                        }
                    }
                    if (!match) break;
                }
                if (match) {
                    digit = @intCast(u8, '0' + d);
                    found = true;
                    break;
                }
            }
            
            result[result_idx] = digit;
            result_idx += 1;
        }
        
        // Add comma if not last group
        if (row_group + 4 < input.len) {
            result[result_idx] = ',';
            result_idx += 1;
        }
    }
    
    return result[0..result_idx];
}
