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

    var verse = start_verse;
    while (verse <= end_verse) : (verse += 1) {
        const idx = @intCast(verse - 1);
        const animal = animals[idx];

        if (!first_verse) {
            try writer.writeAll("\n\n");
        }
        first_verse = false;

        try writer.print("I know an old lady who swallowed a {s}.\n", .{animal});
        try writer.print("{s}\n", .{comments[idx]});

        if (verse == 8) {
            continue;
        }

        if (verse >= 2) {
            var i = idx;
            while (i >= 2) : (i -= 1) {
                if (i == 2) {
                    try writer.print("She swallowed the {s} to catch the spider that wriggled and jiggled and tickled inside her.\n", .{animals[i]});
                } else {
                    try writer.print("She swallowed the {s} to catch the {s}.\n", .{animals[i], animals[i - 1]});
                }
            }
            try writer.print("She swallowed the spider to catch the fly.\n");
        }

        try writer.print("{s}", .{fly_ending});
    }

    return buffer[0..writer.bytesWritten()];
}
