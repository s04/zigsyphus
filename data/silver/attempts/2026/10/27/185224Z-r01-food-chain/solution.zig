const std = @import("std");

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    var pos: usize = 0;

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
        "",
        "It wriggled and jiggled and tickled inside her.",
        "How absurd to swallow a bird!",
        "Imagine that, to swallow a cat!",
        "What a hog, to swallow a dog!",
        "Just opened her throat and swallowed a goat!",
        "I don't know how she swallowed a cow!",
        "She's dead, of course!",
    };

    const final_line = "I don't know why she swallowed the fly. Perhaps she'll die.";

    var verse: u32 = start_verse;
    while (verse <= end_verse) : (verse += 1) {
        const v = @intCast(verse);
        const animal = animals[v - 1];

        // First line of every verse
        pos = try appendFmt(buffer, pos, "I know an old lady who swallowed a {s}.\n", .{animal});

        if (verse == 8) {
            // Horse - special ending
            pos = try appendFmt(buffer, pos, "{s}\n", .{comments[7]});
        } else if (verse == 1) {
            // Fly - just the final line
            pos = try appendFmt(buffer, pos, "{s}\n", .{final_line});
        } else {
            // Verses 2-7: comment, catch lines, final line
            pos = try appendFmt(buffer, pos, "{s}\n", .{comments[v - 1]});

            // Catch lines from current animal down to spider
            var j: u32 = verse;
            while (j >= 2) : (j -= 1) {
                const current = animals[@intCast(j) - 1];
                if (j == 2) {
                    pos = try appendFmt(buffer, pos, "She swallowed the {s} to catch the fly.\n", .{current});
                } else if (j == 3) {
                    pos = try appendFmt(buffer, pos, "She swallowed the {s} to catch the spider that wriggled and jiggled and tickled inside her.\n", .{current});
                } else {
                    const previous = animals[@intCast(j) - 2];
                    pos = try appendFmt(buffer, pos, "She swallowed the {s} to catch the {s}.\n", .{current, previous});
                }
            }

            pos = try appendFmt(buffer, pos, "{s}\n", .{final_line});
        }

        // Blank line between verses (not after the last verse)
        if (verse != end_verse) {
            if (pos >= buffer.len) return error.BufferTooSmall;
            buffer[pos] = '\n';
            pos += 1;
        }
    }

    return buffer[0..pos];
}

fn appendFmt(buf: []u8, pos: usize, comptime fmt: []const u8, args: anytype) !usize {
    const written = try std.fmt.bufPrint(buf[pos..], fmt, args);
    return pos + written;
}
