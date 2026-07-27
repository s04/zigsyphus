const std = @import("std");

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    const ordinals = [12][]const u8{
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
        "tenth",
        "eleventh",
        "twelfth",
    };

    const gifts = [12][]const u8{
        "a Partridge in a Pear Tree",
        "two Turtle Doves",
        "three French Hens",
        "four Calling Birds",
        "five Gold Rings",
        "six Geese-a-Laying",
        "seven Swans-a-Swimming",
        "eight Maids-a-Milking",
        "nine Ladies Dancing",
        "ten Lords-a-Leaping",
        "eleven Pipers Piping",
        "twelve Drummers Drumming",
    };

    var cursor: usize = 0;

    for (start_verse..end_verse + 1) |v| {
        const day_idx = v - 1;
        const prefix = "On the ";
        const mid = " day of Christmas my true love gave to me: ";

        std.mem.copy(u8, buffer[cursor..], prefix);
        cursor += prefix.len;
        std.mem.copy(u8, buffer[cursor..], ordinals[day_idx]);
        cursor += ordinals[day_idx].len;
        std.mem.copy(u8, buffer[cursor..], mid);
        cursor += mid.len;

        for (0..v) |i| {
            const gift_idx = v - 1 - i;
            const gift = gifts[gift_idx];
            std.mem.copy(u8, buffer[cursor..], gift);
            cursor += gift.len;

            if (i < v - 1) {
                buffer[cursor] = ',';
                buffer[cursor + 1] = ' ';
                cursor += 2;
            } else {
                if (v == 1) {
                    buffer[cursor] = '.';
                    cursor += 1;
                } else {
                    const suffix = ", and a Partridge in a Pear Tree.";
                    std.mem.copy(u8, buffer[cursor..], suffix);
                    cursor += suffix.len;
                }
            }
        }

        if (v < end_verse) {
            buffer[cursor] = '\n';
            cursor += 1;
        }
    }

    return buffer[0..cursor];
}
