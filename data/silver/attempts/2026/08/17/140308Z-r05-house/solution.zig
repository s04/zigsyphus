const std = @import("std");

const verses = [
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
];

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    if (start_verse < 1 or end_verse < start_verse or start_verse > verses.len or end_verse > verses.len) {
        return error.IndexOutOfBounds;
    }

    var pos: usize = 0;
    for (start_verse..end_verse + 1) |i| {
        const verse = verses[i - 1];
        // copy the verse
        for (verse) |c| {
            if (pos >= buffer.len) return error.BufferOverflow;
            buffer[pos] = c;
            pos += 1;
        }
        // add newline after the verse
        if (pos >= buffer.len) return error.BufferOverflow;
        buffer[pos] = '\n';
        pos += 1;
    }
    return buffer[0..pos];
}
