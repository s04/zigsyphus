const std = @import("std");

pub fn recite(buffer: []u8, start_bottles: u32, take_down: u32) ![]const u8 {
    // Helper to convert a number (0..10) to its word representation.
    // 0 -> "no", 1 -> "One", 2 -> "Two", ..., 10 -> "Ten".
    const words = [_][]const u8{
        "no", "One", "Two", "Three", "Four", "Five",
        "Six", "Seven", "Eight", "Nine", "Ten",
    };
    const word = struct {
        fn get(n: u32) []const u8 {
            std.debug.assert(n <= 10);
            return words[n];
        }
    };

    var offset: usize = 0;
    for (0..take_down) |i| {
        const current = start_bottles - @intCast(u32, i);
        const next = current - 1;

        // First line
        offset += try std.fmt.format(
            buffer[offset..],
            "{s} green bottle{?s} hanging on the wall,\n",
            .{
                word.get(current),
                if (current == 1) "" else "s",
            },
        );

        // Second line (identical to first)
        offset += try std.fmt.format(
            buffer[offset..],
            "{s} green bottle{?s} hanging on the wall,\n",
            .{
                word.get(current),
                if (current == 1) "" else "s",
            },
        );

        // Third line
        offset += try std.fmt.format(
            buffer[offset..],
            "And if one green bottle should accidentally fall,\n",
            .{},
        );

        // Fourth line
        if (i == take_down - 1) {
            // Last verse: no trailing newline
            offset += try std.fmt.format(
                buffer[offset..],
                "There'll be {s} green bottle{?s} hanging on the wall.",
                .{
                    word.get(next),
                    if (next == 1) "" else "s",
                },
            );
        } else {
            offset += try std.fmt.format(
                buffer[offset..],
                "There'll be {s} green bottle{?s} hanging on the wall.\n",
                .{
                    word.get(next),
                    if (next == 1) "" else "s",
                },
            );
        }

        // Blank line between verses, except after the last one
        if (i != take_down - 1) {
            offset += try std.fmt.format(buffer[offset..], "\n", .{});
        }
    }

    return buffer[0..offset];
}
