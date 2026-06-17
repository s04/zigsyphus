const std = @import("std");

pub fn convert(buffer: []u8, n: u32) []const u8 {
    var index: usize = 0;

    if (n % 3 == 0) {
        const s = "Pling";
        for (s) |c| {
            buffer[index] = c;
            index += 1;
        }
    }

    if (n % 5 == 0) {
        const s = "Plang";
        for (s) |c| {
            buffer[index] = c;
            index += 1;
        }
    }

    if (n % 7 == 0) {
        const s = "Plong";
        for (s) |c| {
            buffer[index] = c;
            index += 1;
        }
    }

    if (index == 0) {
        return std.fmt.bufPrint(buffer[0..], "{}", .{n}) catch unreachable;
    } else {
        return buffer[0..index];
    }
}
