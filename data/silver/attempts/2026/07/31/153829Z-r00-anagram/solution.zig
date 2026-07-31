const std = @import("std");
const mem = std.mem;

/// Returns the set of strings in `candidates` that are anagrams of `word`.
/// Caller owns the returned memory.
pub fn detectAnagrams(
    allocator: mem.Allocator,
    word: []const u8,
    candidates: []const []const u8,
) !std.BufSet {
    var result = std.BufSet.init(allocator);
    defer {
        // Note: we don't defer deinit because caller owns the returned memory
        // But we need to handle errors properly
    }

    // Create lowercase version of target word
    var word_lower = try allocator.alloc(u8, word.len);
    defer allocator.free(word_lower);
    for (word, 0..) |c, i| {
        word_lower[i] = std.ascii.toLower(c);
    }

    // Count characters in target word
    var word_counts: [26]usize = .{0} ** 26;
    for (word_lower) |c| {
        if (c >= 'a' and c <= 'z') {
            word_counts[c - 'a'] += 1;
        }
    }

    for (candidates) |candidate| {
        // Skip if different length
        if (candidate.len != word.len) continue;

        // Skip if case-insensitive equal to word (not an anagram of itself)
        if (mem.eql(u8, candidate, word)) continue;
        var candidate_lower = try allocator.alloc(u8, candidate.len);
        for (candidate, 0..) |c, i| {
            candidate_lower[i] = std.ascii.toLower(c);
        }
        if (mem.eql(u8, candidate_lower, word_lower)) {
            allocator.free(candidate_lower);
            continue;
        }

        // Count characters in candidate
        var candidate_counts: [26]usize = .{0} ** 26;
        for (candidate_lower) |c| {
            if (c >= 'a' and c <= 'z') {
                candidate_counts[c - 'a'] += 1;
            }
        }
        allocator.free(candidate_lower);

        // Check if counts match
        var is_anagram = true;
        for (word_counts, candidate_counts) |wc, cc| {
            if (wc != cc) {
                is_anagram = false;
                break;
            }
        }

        if (is_anagram) {
            try result.put(candidate);
        }
    }

    return result;
}
