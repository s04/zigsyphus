const std = @import("std");
const mem = std.mem;

pub const TransmissionError = error{
    WrongParity,
};

pub fn transmitSequence(allocator: mem.Allocator, message: []const u8) ![]u8 {
    var list = std.ArrayList(u8).init(allocator);
    errdefer list.deinit();
    var buffer: u16 = 0;
    var bits_available: u8 = 0;
    var i: usize = 0;
    while (i < message.len) {
        if (bits_available < 7) {
            buffer = (buffer << 8) | @as(u16, message[i]);
            bits_available += 8;
            i += 1;
        }
        const shift_amount = bits_available - 7;
        const chunk = @truncate(u8, (buffer >> shift_amount) & 0x7F);
        buffer &= @as(u16, (1) << shift_amount) - 1;
        bits_available -= 7;
        const parity = @popCount(chunk) & 1;
        const transmitted = (chunk << 1) | @as(u8, parity);
        try list.append(transmitted);
    }
    if (bits_available > 0) {
        const chunk = @truncate(u8, buffer << (7 - bits_available));
        const parity = @popCount(chunk) & 1;
        const transmitted = (chunk << 1) | @as(u8, parity);
        try list.append(transmitted);
    }
    return list.toOwnedSlice();
}

pub fn decodeMessage(allocator: mem.Allocator, message: []const u8) (mem.Allocator.Error || TransmissionError)![]u8 {
    var list = std.ArrayList(u8).init(allocator);
    errdefer list.deinit();
    var buffer: u32 = 0;
    var bits_available: u8 = 0;
    for (message) |byte| {
        const data7 = byte >> 1;
        const parity = byte & 1;
        const expectedParity = @popCount(data7) & 1;
        if (parity != expectedParity) {
            return error.WrongParity;
        }
        buffer = (buffer << 7) | data7;
        bits_available += 7;
        while (bits_available >= 8) {
            const shift = bits_available - 8;
            const out = @truncate(u8, (buffer >> shift) & 0xFF);
            try list.append(out);
            buffer &= @as(u32, (1) << shift) - 1;
            bits_available -= 8;
        }
    }
    return list.toOwnedSlice();
}
