const std = @import("std");
const mem = std.mem;

fn isVowel(c: u8) bool {
    return c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u';
}

fn translateWord(allocator: mem.Allocator, word: []const u8) mem.Allocator.Error![]u8 {
    // Rule 1: starts with a vowel
    if word.len > 0 and isVowel(word[0]) {
        return try mem.concat(allocator, u8, &[_][]const u8{word, "ay"});
    }
    // Rule 1: starts with "xr" or "yt"
    if word.len >= 2 and ((word[0] == 'x' and word[1] == 'r') or (word[0] == 'y' and word[1] == 't')) {
        return try mem.concat(allocator, u8, &[_][]const u8{word, "ay"});
    }

    // Find the split index for the initial consonant cluster
    var i: usize = 0;
    while (i < word.len) : (i += 1) {
        const c = word[i];
        if (isVowel(c)) {
            break;
        }
        if (c == 'y' and i > 0) {
            break;
        }
        if (c == 'q' and i + 1 < word.len and word[i + 1] == 'u') {
            i += 1; // skip the 'u' as part of the "qu" cluster
            continue;
        }
    }

    const prefix = word[0..i];
    const suffix = word[i..];
    return try mem.concat(allocator, u8, &[_][]const u8{suffix, prefix, "ay"});
}

pub fn translate(allocator: mem.Allocator, phrase: []const u8) mem.Allocator.Error![]u8 {
    var words = std.mem.split(u8, phrase, " ");
    var translated_words = std.ArrayList([]const u8).init(allocator);
    defer translated_words.deinit();

    while (words.next()) |word| {
        const translated = try translateWord(allocator, word);
        try translated_words.append(translated);
    }

    return try mem.join(allocator, " ", translated_words.items);
}
