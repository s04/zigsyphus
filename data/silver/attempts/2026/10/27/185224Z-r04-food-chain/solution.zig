const std = @import("std");

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    const animals = [_][]const u8{
        "fly",
        "spider",
        "bird",
        "cat",
        "dog",
        "goat",
        "cow",
        "horse",
    };

    const comments = [_][]const u8{
        "I don't know why she swallowed the fly. Perhaps she'll die.",
        "It wriggled and jiggled and tickled inside her.",
        "How absurd to swallow a bird!",
        "Imagine that, to swallow a cat!",
        "What a hog, to swallow a dog!",
        "Just opened her throat and swallowed a goat!",
        "I don't know how she swallowed a cow!",
        "She's dead, of course!",
    };

    const fly_ending = "I don't know why she swallowed the fly. Perhaps she'll die.";

    var writer = std.io.fixedBufferStream(&buffer).writer();
    var first_verse = true;

    for (start_verse..=end_verse) |verse_num| {
        const idx = @intCast(verse_num - 1);
        const animal = animals[idx];

        if (!first_verse) {
            try writer.writeAll("\n\n");
        }
        first_verse = false;

        // Intro line
        try writer.print("I know an old lady who swallowed a {s}.\n", .{animal});

        // Comment line
        try writer.print("{s}\n", .{comments[idx]});

        // Horse is special - no chain, no fly ending
        if (verse_num == 8) {
            continue;
        }

        // Build the chain from current animal down to spider (index 1)
        if (verse_num >= 2) {
            for (idx..1) |i| {
                const predator = animals[i];
                const prey = animals[i - 1];
                if (i == 1) {
                    // Spider catching fly
                    try writer.print("She swallowed the {s} to catch the {s}.\n", .{predator, prey});
                } else if (i == 2) {
                    // Bird catching spider - special description
                    try writer.print("She swallowed the {s} to catch the spider that wriggled and jiggled and tickled inside her.\n", .{predator});
                } else {
                    // Normal chain
                    try writer.print("She swallowed the {s} to catch the {s}.\n", .{predator, prey});
                }
            }
        }

        // Fly ending for verses 1-7
        try writer.print("{s}", .{fly_ending});
    }

    return buffer[0..writer.bytesWritten()];
}
