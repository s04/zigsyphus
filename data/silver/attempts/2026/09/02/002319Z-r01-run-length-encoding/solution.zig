pub fn encode(buffer: []u8, string: []const u8) []u8 {
    var out: usize = 0;
    var i: usize = 0;
    while (i < string.len) {
        var count: usize = 1;
        while (i + count < string.len and string[i + count] == string[i]) {
            count += 1;
        }
        if (count > 1) {
            const digits = std.fmt.count("{d}", .{count});
            for (0..digits) |d| {
                const c = count / std.math.pow(usize, 10, digits - d - 1) % 10;
                buffer[out] = @as(u8, @intCast(c)) + '0';
                out += 1;
            }
        }
        buffer[out] = string[i];
        out += 1;
        i += count;
    }
    return buffer[0..out];
}

pub fn decode(buffer: []u8, string: []const u8) []u8 {
    var out: usize = 0;
    var i: usize = 0;
    while (i < string.len) {
        if (string[i] >= '0' and string[i] <= '9') {
            var count: usize = 0;
            while (i < string.len and string[i] >= '0' and string[i] <= '9') {
                count = count * 10 + (string[i] - '0');
                i += 1;
            }
            if (i < string.len) {
                for (0..count) |_| {
                    buffer[out] = string[i];
                    out += 1;
                }
                i += 1;
            } else {
                for (0..count) |_| {
                    buffer[out] = '0';
                    out += 1;
                }
            }
        } else {
            buffer[out] = string[i];
            out += 1;
            i += 1;
        }
    }
    return buffer[0..out];
}

const std = @import("std");
