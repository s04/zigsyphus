const std = @import("std");
const mem = std.mem;

pub const TransmissionError = error{
    WrongParity,
};

pub fn transmitSequence(allocator: mem.Allocator, message: []const u8) mem.Allocator.Error![]u8 {
    if (message.len == 0) {
        return &[]u8{};
    }
    const total_bits: usize = message.len * 8;
    const out_len: usize = (total_bits + 6) / 7; // ceil(total_bits / 7)
    var out = try allocator.alloc(u8, out_len);
    var out_index: usize = 0;
    var bit_index: usize = 0; // position in the input bit stream
    while (out_index < out_len) {
        var data: u8 = 0;
        var bits_taken: u8 = 0;
        while (bits_taken < 7) {
            var bit: u8 = 0;
            if (bit_index < total_bits) {
                const byte_index = bit_index / 8;
                const bit_in_byte = 7 - (bit_index % 8); // MSB first
                bit = (message[byte_index] >> bit_in_byte) & 1;
            } else {
                bit = 0; // padding zero
            }
            data = (data << 1) | bit;
            bits_taken += 1;
            bit_index += 1;
        }
        const ones: u8 = std.mem.countBits(data);
        const parity: u8 = ones % 2;
        out[out_index] = (data << 1) | parity;
        out_index += 1;
    }
    return out;
}

pub fn decodeMessage(allocator: mem.Allocator, message: []const u8) (mem.Allocator.Error || TransmissionError)![]u8 {
    if (message.len == 0) {
        return &[]u8{};
    }
    const total_data_bits: usize = message.len * 7;
    const out_len: usize = total_data_bits / 8; // floor(total_data_bits / 8)
    var out: ?[]u8 = null;
    if (out_len > 0) {
        out = try allocator.alloc(u8, out_len);
    }
    var out_index: usize = 0;
    var bit_buffer: u16 = 0;
    var bits_in_buffer: u8 = 0;
    for (message) |b| {
        if (std.mem.countBits(b) % 2 == 1) {
            if (out) |*ptr| {
                allocator.free(ptr);
            }
            return error.WrongParity;
        }
        var data: u8 = b >> 1; // extract the 7 data bits (MSB is bit6)
        for (0..7) |i| {
            const bit: u8 = (data >> (6 - i)) & 1;
            bit_buffer = (bit_buffer << 1) | bit;
            bits_in_buffer += 1;
            if (bits_in_buffer == 8) {
                if (out) |*ptr| {
                    ptr[out_index] = @truncate(bit_buffer);
                }
                out_index += 1;
                bit_buffer = 0;
                bits_in_buffer = 0;
            }
        }
    }
    if (out) |*ptr| {
        return ptr;
    } else {
        return &[]u8{};
    }
}
