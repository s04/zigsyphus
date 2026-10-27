const std = @import("std");
const fmt = std.fmt;

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
        const animal = animals[@as(usize, verse - 1)];

        // First line of the verse
        pos = try appendLine(buffer, pos, "I know an old lady who swallowed a {s}.", .{animal});

        if (verse == 8) {
            // Horse verse: only the special comment
            pos = try appendLine(buffer, pos, "{s}", .{comments[7]});
        } else if (verse == 1) {
            // Fly verse: only the final line
            pos = try appendLine(buffer, pos, "{s}", .{final_line});
        } else {
            // Verses 2-7: comment, catch lines, final line
            pos = try appendLine(buffer, pos, "{s}", .{comments[@as(usize, verse - 1)]});

            // Catch lines from current animal down to spider
            var j: u32 = verse;
            while (j >= 2) : (j -= 1) {
                const current = animals[@as(usize, j - 1)];
                if (j == 2) {
                    pos = try appendLine(buffer, pos, "She swallowed the spider to catch the fly.", .{});
                } else if (j == 3) {
                    pos = try appendLine(buffer, pos, "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.", .{});
                } else {
                    const previous = animals[@as(usize, j - 2)];
                    pos = try appendLine(buffer, pos, "She swallowed the {s} to catch the {s}.", .{ current, previous });
                }
            }

            // Final line
            pos = try appendLine(buffer, pos, "{s}", .{final_line});
        }

        // Blank line between verses (not after the last verse)
        if (verse != end_verse) {
            pos = try appendChar(buffer, pos, '\n');
        }
    }

    // Remove trailing newline if present
    if (pos > 0 and buffer[pos - 1] == '\n') {
        pos -= 1;
    }

    return buffer[0..pos];
}

fn appendLine(buf: []u8, pos: usize, comptime fmt_str: []const u8, args: anytype) !usize {
    const written = try fmt.bufPrint(buf[pos..], fmt_str, args);
    const new_pos = pos + written;
    if (new_pos >= buf.len) return error.BufferTooSmall;
    buf[new_pos] = '\n';
    return new_pos + 1;
}

fn appendChar(buf: []u8, pos: usize, c: u8) !usize {
    if (pos >= buf.len) return error.BufferTooSmall;
    buf[pos] = c;
    return pos + 1;
}
