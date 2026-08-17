const std = @import("std");

const verses: [12]const []const u8 = const [
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
    "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."
];

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    const buf_len = buffer.len;
    var pos = 0u;
    for (start_verse - 1 .. end_verse) |i, verse_idx| {
        // write newline before each verse
        buffer[pos] = '\n';
        pos += 1;

        // write the verse text, skipping the null terminator
        const verse = verses[verse_idx];
        var j = 0u;
        while (j < verse.len) {
            if (verse[j] == 0u) break;
            buffer[pos] = verse[j];
            pos += 1;
            j += 1;
        }
    }
    return buffer;
}
