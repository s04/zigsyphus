pub const DnaError = error{
    EmptyDnaStrands,
    UnequalDnaStrands,
};

pub fn compute(first: []const u8, second: []const u8) DnaError!usize {
    if (first.len == 0 or second.len == 0) {
        return error.EmptyDnaStrands;
    }
    if (first.len != second.len) {
        return error.UnequalDnaStrands;
    }
    var count: usize = 0;
    for (first, second) |a, b| {
        if (a != b) {
            count += 1;
        }
    }
    return count;
}
