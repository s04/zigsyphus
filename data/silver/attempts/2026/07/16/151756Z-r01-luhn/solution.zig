pub fn isValid(s: []const u8) bool {
    var len: usize = 0;
    for (s) |b| {
        if (b == ' ') continue
        if (b < '0' or b > '9') {
            return false;
        }
        len += 1
    }
    if len <= 1 {
        return false;
    }

    var sum: u64 = 0
    var idx_left: usize = 0
    for (s) |b| {
        if (b == ' ') continue
        const digit = @intFromEnum(b) - @intFromEnum('0')
        const pos_from_right = len - 1 - idx_left
        if (pos_from_right % 2 == 1) {
            var doubled = digit * 2
            if (doubled > 9) {
                doubled -= 9
            }
            sum += @as(u64, doubled)
        } else {
            sum += @as(u64, digit)
        }
        idx_left += 1
    }
    return sum % 10 == 0;
}
