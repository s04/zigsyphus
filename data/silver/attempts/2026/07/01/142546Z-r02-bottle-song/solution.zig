```zig
const std = @import("std");

pub fn recite(buffer: []u8, start_bottles: u32, take_down: u32) ![]const u8 {
    const MAX_BUFFER_SIZE: usize = 4000;
    var buffer: []u8 = &[MAX_BUFFER_SIZE]u8{};
    var offset: usize = 0;

    const words: [11][]const u8 = const [
        undefined,
        "One",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine",
        "Ten"
    ];

    const append = @inline (s: []const u8) : void {
        for (i: 0..s.len) : (i) {
            buffer[offset] = s[i];
            offset += 1;
        }
    };

    for (u32 v = 0; v < take_down; v += 1) {
        const n = start_bottles - v;

        // line1
        const w1 = words[n];
        const suffix1 = " green bottles hanging on the wall.";
        append(w1);
        for (i: 0..suffix1.len) : (i) {
            buffer[offset] = suffix1[i];
            offset += 1;
        }
        buffer[offset] = '\n';
        offset += 1;

        // line2 (same as line1)
        append(w1);
        for (i: 0..suffix1.len) : (i) {
            buffer[offset] = suffix1[i];
            offset += 1;
        }
        buffer[offset] = '\n';
        offset += 1;

        // line3
        const line3_prefix = "And if one green bottle should accidentally fall, there'll be ";
        for (i: 0..line3_prefix.len) : (i) {
            buffer[offset] = line3_prefix[i];
            offset += 1;
        }
        const w3 = if n == 1 {
            "no"
        } else {
            words[n - 1]
        };
        for (i: 0..w3.len) : (i) {
            buffer[offset] = w3[i];
            offset += 1;
        }
        const suffix3 = " green bottles hanging on the wall.";
        for (i: 0..suffix3.len) : (i) {
