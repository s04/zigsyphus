pub fn isValidIsbn10(s: []const u8) bool {
    var pos: usize = 0;
    var sum: u32 = 0;

    for (s) |c| {
        if (c == '-') continue;

        const is_last = (pos == 9);
        var value: u32 = 0;

        if (c >= '0' and c <= '9') {
            value = @intCast(c - '0');
        } else if (is_last and c == 'X') {
            value = 10;
        } else {
            return false;
        }

        const weight: u32 = @u32(10) - @u32(@intCast(pos));
        sum += value * weight;
        pos += 1;
    }

    if (pos != 10) return false;
    return (sum % 11) == 0;
}
