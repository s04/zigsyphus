const std = @import("std");

const verse_data: [12][]const u8 =.{
    "This is the house that Jack built.",
    "This is the malt that lay in the house that Jack built.",
    "This is the rat that ate the malt that lay in the house that Jack built.",
    "This is the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
    "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
};

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32)![]const u8 {
    var pos: usize = 0;
    for (start_verse..=end_verse) |i| {
        const idx = i - 1;
        if (idx >= verse_data.len) return error.IndexOutOfBounds;

        const verse = verse_data[idx];

        // If not the first verse in the requested range, add a newline
        if (i > start_verse) {
            if (pos >= buffer.len) return error.BufferOverflow;
            buffer[pos] = '\n';
            pos += 1;
        }

        // Copy the verse content
        for (verse) |c| {
            if (pos >= buffer.len) return error.BufferOverflow;
            buffer[pos] = c;
            pos += 1;
        }

        // Add a newline after every verse except the very last one in the total sequence?
        // No, the tests expect a newline between verses, but not necessarily at the end of the last one.
        // Looking at the test "multiple verses", it expects:
        // "This is the cat...built.\nThis is the dog...built.\n..."
        // This means a newline is a separator.
        if (i < end_verse) {
            if (pos >= buffer.len) return error.BufferOverflow;
            buffer[pos] = '\n';
            pos += 1;
        }
    }

    return buffer[0..pos];
}
