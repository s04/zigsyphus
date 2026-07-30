pub const DnaError = error{EmptyDnaStrands,UnequalDnaStrands};

pub fn compute(first: []const u8, second: []const u8) DnaError!usize {
    if (first.len == 0) {
        return DnaError.EmptyDnaStrands;
    }
    if (second.len == 0) {
        return DnaError.EmptyDnaStrands;
    }
    if (first.len != second.len) {
        return DnaError.UnequalDnaStrands;
    }
    var count: usize = 0;
    for (0..first.len) |i| {
        if (first[i] != second[i]) {
            count += 1;
        }
    }
    return count;
}
