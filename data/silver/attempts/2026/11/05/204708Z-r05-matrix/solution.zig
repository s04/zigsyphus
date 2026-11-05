const std = @import("std");
const mem = std.mem;

/// Returns the selected row of the matrix.
pub fn row(allocator: mem.Allocator, s: []const u8, index: i32) ![]i16 {
    if (index < 1) return error.InvalidIndex;

    var row_start: usize = 0;
    var row_idx: i32 = 1;
    var i: usize = 0;

    while (i < s.len) {
        if (row_idx == index) break;
        if (s[i] == '\n') {
            row_idx += 1;
            row_start = i + 1;
        }
        i += 1;
    }

    if (row_idx != index) return error.InvalidIndex;

    var row_end = row_start;
    while (row_end < s.len and s[row_end] != '\n') row_end += 1;

    const line = s[row_start..row_end];
    return parseNumbers(allocator, line);
}

/// Returns the selected column of the matrix.
pub fn column(allocator: mem.Allocator, s: []const u8, index: i32) ![]i16 {
    if (index < 1) return error.InvalidIndex;

    var row_count: usize = 1;
    for (s) |c| if (c == '\n') row_count += 1;

    var result = try allocator.alloc(i16, row_count);
    var r_idx: usize = 0;

    var row_start: usize = 0;
    var i: usize = 0;
    while (i <= s.len) {
        if (i == s.len or s[i] == '\n') {
            const line = s[row_start..i];
            var val: i16 = undefined;
            var found = false;

            var col_idx: i32 = 1;
            var j: usize = 0;
            while (j < line.len) {
                while (j < line.len and line[j] == ' ') j += 1;
                if (j < line.len) {
                    if (col_idx == index) {
                        var start = j;
                        while (j < line.len and line[j] != ' ') j += 1;
                        val = try std.fmt.parseInt(i16, line[start..j], 10);
                        found = true;
                        break;
                    }
                    col_idx += 1;
                    while (j < line.len and line[j] != ' ') j += 1;
                }
            }

            if (!found) return error.InvalidIndex;
            result[r_idx] = val;
            r_idx += 1;
            row_start = i + 1;
        }
        i += 1;
    }

    return result;
}

fn parseNumbers(allocator: mem.Allocator, line: []const u8) ![]i16 {
    var count: usize = 0;
    var i: usize = 0;
    while (i < line.len) {
        while (i < line.len and line[i] == ' ') i += 1;
        if (i < line.len) {
            count += 1;
            while (i < line.len and line[i] != ' ') i += 1;
        }
    }

    var nums = try allocator.alloc(i16, count);
    var idx: usize = 0;
    i = 0;
    while (i < line.len) {
        while (i < line.len and line[i] == ' ') i += 1;
        if (i < line.len) {
            var start = i;
            while (i < line.len and line[i] != ' ') i += 1;
            nums[idx] = try std.fmt.parseInt(i16, line[start..i], 10);
            idx += 1;
        }
    }
    return nums;
}
