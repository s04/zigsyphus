pub const DnaError = error{
    EmptyDnaStrands,
    UnequalDnaStrands,
};

pub fn compute(first: []const u8, second: []const u8) DnaError!usize {
    // Check for empty strands
    if (first.len == 0 or second.len == 0) {
        return DnaError.EmptyDnaStrands;
    }

    // Check for unequal lengths
    if (first.len != second.len) {
        return DnaError.UnequalDnaStrands;
    }

    var diff: usize = 0;
    for (first, second) |a, b| {
        if (a != b) diff += 1;
    }
    return diff;
}
