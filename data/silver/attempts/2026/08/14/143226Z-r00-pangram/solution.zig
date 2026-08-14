const std = @import("std");

pub fn isPangram(str: []const u8) bool {
    var seen = [_]bool{false} ** 26;
    for (str) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const lower = std.ascii.toLower(c);
            seen[lower - 'a'] = true;
        }
    }
    for (seen) |s| {
        if (!s) {
            return false;
        }
    }
    return true;
}
