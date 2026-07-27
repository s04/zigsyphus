pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32)![]const u8 {
    const ordinals = [
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
    ];

    const gifts = [
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
    ];

    const iter = std.mem.tokenizeScalar(u8, "\n", "");
    var cursor: usize = 0;

    for (start_verse..end_verse + 1) |v| {
        const day_idx = v - 1;
        
        // Write "On the [ordinal] day of Christmas my true love gave to me: "
        const prefix = "On the ";
        const mid = " day of Christmas my true love gave to me: ";
        
        if (cursor + prefix.len + ordinals[day_idx].len + mid.len > buffer.len) return error.BufferTooSmall;
        
        @memcpy(buffer[cursor.. cursor + prefix.len], prefix);
        cursor += prefix.len;
        @memcpy(buffer[cursor.. cursor + ordinals[day_idx].len], ordinals[day_idx]);
        cursor += ordinals[day_idx].len;
        @memcpy(buffer[cursor.. cursor + mid.len], mid);
        cursor += mid.len;

        // Write gifts in reverse order
        for (0..v) |i| {
            const gift_idx = v - 1 - i;
            const gift = gifts[gift_idx];
            
            if (cursor + gift.len > buffer.len) return error.BufferTooSmall;
            
            @memcpy(buffer[cursor.. cursor + gift.len], gift);
            cursor += gift.len;

            if (i < v - 1) {
                if (cursor + 2 > buffer.len) return error.BufferTooSmall;
                buffer[cursor] = ',';
                buffer[cursor + 1] = ';
                cursor += 2;
            } else {
                // Last gift for the first verse is special: ", and a Partridge..."
                // But wait, the pattern for verse 1 is "a Partridge in a Pear Tree."
                // The pattern for verse > 1 is "... [last gift], and a Partridge in a Pear Tree."
                // Let's look at the requirement carefully.
                // Verse 1: "a Partridge in a Pear Tree."
                // Verse 2: "two Turtle Doves, and a Partridge in a Pear Tree."
                // This means for v=1, we just add "."
                // For v>1, we add ", and a Partridge in a Pear Tree."
                if (v == 1) {
                    if (cursor + 1 > buffer.len) return error.BufferSmall;
                    buffer[cursor] = '.';
                    cursor += 1;
                } else {
                    if (cursor + 35 > buffer.len) return error.BufferSmall;
                    @memcpy(buffer[cursor.. cursor + 35], ", and a Partridge in a Pear Tree.");
                    cursor += 35;
                }
            }
        }

        if (v < end_verse) {
            if (cursor + 1 > buffer.len) return error.BufferSmall;
            buffer[cursor] = '\n';
            cursor += 1;
        }
    }

    return buffer[0..cursor];
}
