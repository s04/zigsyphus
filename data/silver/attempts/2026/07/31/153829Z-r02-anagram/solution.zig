const std = @import("std");
const mem = std.mem;

/// Returns the set of strings in `candidates` that are anagrams of `word`.
/// Caller owns the returned memory.
pub fn detectAnagrams(
    allocator: mem.Allocator,
    word: []const u8,
    candidates: []const []const u8,
) !std.BufSet {
    const word_lower = try allocator.alloc(u8, word.len);
    defer allocator.free(word_lower);
    for (word, 0..) |c, i| {
        word_lower[i] = std.ascii.toLower(c);
    }

    var word_counts: [26]usize = std.mem.zeroes([26]usize);
    for (word_lower) |c| {
        if (c >= 'a' and c <= 'z') {
            word_counts[c - 'a'] += 1;
        }
    }

    const result = try std.BufSet.init(allocator);

    for (candidates) |candidate| {
        if (candidate.len != word.len) continue;
        if (mem.eql(u8, candidate, word)) continue;

        const candidate_lower = try allocator.alloc(u8, candidate.len);
        defer allocator.free(candidate_lower);
        for (candidate, 0..) |c, i| {
            candidate_lower[i] = std.ascii.toLower(c);
        }

        if (mem.eql(u8, candidate_lower, word_lower)) continue;

        var candidate_counts: [26]usize = std.mem.zeroes([26]usize);
        for (candidate_lower) |c| {
            if (c >= 'a' and c <= 'z') {
                candidate_counts[c - 'a'] += 1;
            }
        }

        var is_anagram = true;
        for (0..26) |i| {
            if (word_counts[i] != candidate_counts[i]) {
                is_anagram = false;
                break;
            }
        }

        if (is_anagram) {
            try result.add(candidate);
        }
    }

    return result;
}
