const std = @import("std");
const mem = std.mem;

const MatrixError = error{ RowNotFound, ColumnNotFound };

pub fn row(allocator: mem.Allocator, s: []const u8, index: i32) ![]i16 {
    var lines = std.mem.splitScalar(u8, s, '\n');
    var i: i32 = 0;
    while (lines.next()) |line| {
        i += 1;
        if (i == index) {
            return parseRow(allocator, line);
        }
    }
    return MatrixError.RowNotFound;
}

pub fn column(allocator: mem.Allocator, s: []const u8, index: i32) ![]i16 {
    var lines = std.mem.splitScalar(u8, s, '\n');
    var list = std.ArrayList(i16).init(allocator);
    defer list.deinit();
    while (lines.next()) |line| {
        var tokens = std.mem.splitScalar(u8, line, ' ');
        var j: i32 = 0;
        var found = false;
        while (tokens.next()) |token| {
            if (j == index - 1) {
                const value = try std.fmt.parseInt(i16, token, 10);
                try list.append(value);
                found = true;
                break;
            }
            j += 1;
        }
        if (!found) {
            return MatrixError.ColumnNotFound;
        }
    }
    return list.toOwnedSlice();
}

fn parseRow(allocator: mem.Allocator, row_str: []const u8) ![]i16 {
    var list = std.ArrayList(i16).init(allocator);
    defer list.deinit();
    var tokens = std.mem.splitScalar(u8, row_str, ' ');
    while (tokens.next()) |token| {
        const value = try std.fmt.parseInt(i16, token, 10);
        try list.append(value);
    }
    return list.toOwnedSlice();
}
