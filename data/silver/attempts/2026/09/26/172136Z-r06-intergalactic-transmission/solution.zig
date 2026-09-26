const std = @import("std");
const mem = std.mem;

pub const TransmissionError = error{
    WrongParity,
};

pub fn transmitSequence(allocator: mem.Allocator, message: []const u8) ![]u8 {
    const bits = message.len * 8;
    const n = if (bits == 0) 0 else (bits + 6) / 7;
    var out = try allocator.alloc(u8, n);
    errdefer allocator.free(out);

    var i: usize = 0;
    var buf: u8 = 0;
    var count: u3 = 0;

    for (message) |b| {
        var bit_idx: u3 = 0;
        while (bit_idx < 8) : (bit_idx += 1) {
            const bit = (b >> (7 - bit_idx)) & 1;
            buf = (buf << 1) | bit;
            count += 1;
            if (count == 7) {
                const parity = @popCount(buf) & 1;
                out[i] = (buf << 1) | parity;
                i += 1;
                buf = 0;
                count = 0;
            }
        }
    }

    if (count > 0) {
        buf = buf << (7 - count);
        const parity = @popCount(buf) & 1;
        out[i] = (buf << 1) | parity;
        i += 1;
    }

    return out[0..i];
}

pub fn decodeMessage(allocator: mem.Allocator, message: []const u8) (mem.Allocator.Error || TransmissionError)![]u8 {
    if (message.len == 0) {
        const empty = try allocator.alloc(u8, 0);
        return empty;
    }

    var acc: u64 = 0;
    var nbits: u32 = 0;
    var out_list: std.ArrayList(u8) = std.ArrayList(u8).init(allocator);
    defer out_list.deinit();

    for (message) |t| {
        const data7 = t >> 1;
        const parity = t & 1;
        if ((@popCount(data7) & 1) != parity) {
            return error.WrongParity;
        }

        acc = (acc << 7) | data7;
        nbits += 7;
        while (nbits >= 8) {
            nbits -= 8;
            const byte = @intCast(u8, (acc >> nbits) & 0xFF);
            try out_list.append(byte);
        }
    }

    // Ignore any leftover bits (<8); they should be zero padding.
    return out_list.toOwnedSlice();
}
