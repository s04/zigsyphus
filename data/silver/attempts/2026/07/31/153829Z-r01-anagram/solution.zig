const std = @import("std");
const mem = std.mem;

/// Returns the set of strings in `candidates` that are anagrams of `word`.
/// Caller owns the returned memory.
pub fn detectAnagrams(
    allocator: mem.Allocator,
    word: []const u8,
    candidates: []const []const u8,
) !std.BufSet {
    // Allocate and lowercase the target word
    const word_lower = try allocator.alloc(u8, word.len);
    defer allocator.free(word_lower);
    for (word, 0..) |c, i| {
        word_lower[i] = std.ascii.toLower(c);
    }

    // Count letters in the target word
    var word_counts: [26]usize = .{0};
    for (word_lower) |c| {
        if (c >= 'a' and c <= 'z') {
            word_counts[c - 'a'] += 1;
        }
    }

    // Initialize result set
    const result = try std.BufSet.init(allocator);

    // Check each candidate
    for (candidates) |candidate| {
        // Different length cannot be an anagram
        if (candidate.len != word.len) continue;

        // Skip if candidate is exactly the same word (case-sensitive)
        if (mem.eql(u8, candidate, word)) continue;

        // Create a lowercase copy of the candidate
        const candidate_lower = try allocator.alloc(u8, candidate.len);
        defer allocator.free(candidate_lower);

        // Lowercase the candidate
        for (candidate, 0..) |c, i| {
            candidate_lower[i] = std.ascii.toLower(c);
        }

        // Skip if case-insensitive match (same word, different case)
        if (mem.eql(u8, candidate_lower, word_lower)) continue;

        // Count letters in the candidate
        var candidate_counts: [26]usize = .{0};
        for (candidate_lower) |c| {
            if (c >= 'a' and c <= 'z') {
                candidate_counts[c - 'a'] += 1;
            }
        }

        // Compare letter counts
        var is_anagram = true;
        for (word_counts, candidate_counts) |wc, cc| {
            if (wc != cc) {
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
