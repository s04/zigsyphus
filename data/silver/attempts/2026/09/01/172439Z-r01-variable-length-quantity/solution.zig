const std = @import("std");
const mem = std.mem;

pub const DecodeError = error{
    IncompleteSequence,
};

pub fn encode(allocator: mem.Allocator, integers: []const u32) mem.Allocator.Error![]u8 {
    var result = try std.ArrayList(u8).initCapacity(allocator, integers.len * 5);
    defer result.deinit();

    for (integers) |integer| {
        if (integer == 0) {
            try result.append(0);
            continue;
        }

        var buffer: [5]u8 = undefined;
        var count: usize = 0;
        var value = integer;

        while (value > 0) {
            buffer[count] = @intCast(u8, value & 0x7F);
            value >>= 7;
            count += 1;
        }

        var i = count;
        while (i > 0) {
            i -= 1;
            var byte = buffer[i];
            if (i != 0) {
                byte |= 0x80;
            }
            try result.append(byte);
        }
    }

    return result.toOwnedSlice();
}

pub fn decode(allocator: mem.Allocator, integers: []const u8) (mem.Allocator.Error || DecodeError)![]u32 {
    var result = try std.ArrayList(u32).initCapacity(allocator, integers.len / 2);
    defer result.deinit();

    var i: usize = 0;
    while (i < integers.len) {
        var value: u32 = 0;
        var byte_count: usize = 0;

        while (true) {
            if (i >= integers.len) {
                return error.IncompleteSequence;
            }

            const byte = integers[i];
            i += 1;
            byte_count += 1;

            value = (value << 7) | (byte & 0x7F);

            if ((byte & 0x80) == 0) {
                break;
            }
        }

        try result.append(value);
    }

    return result.toOwnedSlice();
}
