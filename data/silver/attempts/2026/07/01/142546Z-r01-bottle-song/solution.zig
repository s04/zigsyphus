pub fn recite(buffer: []u8, start_bottles: u32, take_down: u32) ![]const u8 {
    // Corrected: handle the offset properly and ensure proper line breaks
    const words = [_][]const u8{
        "Ten green bottles hanging on the wall",
        "Ten green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be nine green bottles hanging on the wall.",
        "Nine green bottles hanging on the wall",
        "Nine green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be eight green bottles hanging on the wall.",
        "Eight green bottles hanging on the wall",
        "Eight green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be seven green bottles hanging on the wall.",
        "Seven green bottles hanging on the wall",
        "Seven green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be six green bottles hanging on the wall.",
        "Six green bottles hanging on the wall",
        "Six green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be five green bottles hanging on the wall.",
        "Five green bottles hanging on the wall",
        "Five green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be four green bottles hanging on the wall.",
        "Four green bottles hanging on the wall",
        "Four green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be three green bottles hanging on the wall.",
        "Three green bottles hanging on the wall",
        "Three green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be two green bottles hanging on the wall.",
        "Two green bottles hanging on the wall",
        "Two green bottles hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be one green bottle hanging on the wall.",
        "One green bottle hanging on the wall",
        "One green bottle hanging on the wall",
        "And if one green bottle should accidentally fall, there'll be no green bottles hanging on the wall."
    };

    var buffer = [buffer_size]u8;
    for (u32 i = 0; i <= take_down; i++) {
        buffer[offset] = words[i];
        offset += 1;
    }
    return buffer;
}
