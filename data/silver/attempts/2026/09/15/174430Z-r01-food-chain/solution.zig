const std = @import("std");

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    const animals = [_][]const u8{ "fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse" };

    var pos: usize = 0;

    var verse = start_verse;
    while (verse <= end_verse) : (verse += 1) {
        if (verse > start_verse) {
            buffer[pos] = '\n';
            pos += 1;
            buffer[pos] = '\n';
            pos += 1;
        }

        const animal = animals[verse - 1];
        const opening = try std.fmt.bufPrintZ(buffer[pos..], "I know an old lady who swallowed a {s}.\n", .{animal});
        pos += opening.len;

        const special = switch (verse) {
            1 => "I don't know why she swallowed the fly. Perhaps she'll die.\n",
            2 => "It wriggled and jiggled and tickled inside her.\n",
            3 => "How absurd to swallow a bird!\n",
            4 => "Imagine that, to swallow a cat!\n",
            5 => "What a hog, to swallow a dog!\n",
            6 => "Just opened her throat and swallowed a goat!\n",
            7 => "I don't know how she swallowed a cow!\n",
            8 => "She's dead, of course!\n",
            else => unreachable,
        };
        @memcpy(buffer[pos..][0..special.len], special);
        pos += special.len;

        var i = verse;
        while (i >= 2) : (i -= 1) {
            const current = animals[i - 1];
            const target = animals[i - 2];
            if (i - 1 == 2) {
                const line = try std.fmt.bufPrintZ(buffer[pos..], "She swallowed the {s} to catch the {s} that wriggled and jiggled and tickled inside her.\n", .{current, target});
                pos += line.len;
            } else {
                const line = try std.fmt.bufPrintZ(buffer[pos..], "She swallowed the {s} to catch the {s}.\n", .{current, target});
                pos += line.len;
            }
        }

        if (verse >= 2 and verse <= 7) {
            const fly_ending = "I don't know why she swallowed the fly. Perhaps she'll die.\n";
            @memcpy(buffer[pos..][0..fly_ending.len], fly_ending);
            pos += fly_ending.len;
        }
    }

    if (pos > 0 and buffer[pos - 1] == '\n') {
        pos -= 1;
    }

    return buffer[0..pos];
}
