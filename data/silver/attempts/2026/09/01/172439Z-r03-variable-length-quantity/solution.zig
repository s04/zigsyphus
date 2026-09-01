const std = @import("std");
const mem = std.mem;

pub const DecodeError = error{
    IncompleteSequence,
};

pub fn encode(allocator: mem.Allocator, integers: []const u32) mem.Allocator.Error![]u8 {
    var list = std.ArrayList(u8).empty;
    defer list.deinit(allocator);

    for (integers) |value| {
        var v: u32 = value;
        var bytes: [5]u8 = undefined;
        var n: usize = 0;
        bytes[n] = @intCast(v & 0x7F);
        n += 1;
        v >>= 7;
        while (v != 0) {
            bytes[n] = @intCast((v & 0x7F) | 0x80);
            n += 1;
            v >>= 7;
        }
        var i: usize = n;
        while (i > 0) {
            i -= 1;
            try list.append(allocator, bytes[i]);
        }
    }

    return list.toOwnedSlice(allocator);
}

pub fn decode(allocator: mem.Allocator, integers: []const u8) (mem.Allocator.Error || DecodeError)![]u32 {
    var result = std.ArrayList(u32).empty;
    defer result.deinit(allocator);

    var i: usize = 0;
    while (i < integers.len) {
        var value: u32 = 0;
        var shift: u5 = 0;
        var complete = false;
        while (i < integers.len) {
            const byte = integers[i];
            i += 1;
            const part: u32 = @intCast(byte & 0x7F);
            if (shift >= 32) {
                return DecodeError.IncompleteSequence;
            }
            value |= part << shift;
            shift += 7;
            if (byte & 0x80 == 0) {
                complete = true;
                break;
            }
        }
        if (!complete) {
            return DecodeError.IncompleteSequence;
        }
        try result.append(allocator, value);
    }

    return result.toOwnedSlice(allocator);
}
