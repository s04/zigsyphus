pub fn isValidIsbn10(s: []const u8) bool {
    var pos: usize = 0;
    var sum: u32 = 0;

    for (s) |c| {
        if (c == '-') continue;

        const is_last = (pos == 9);
        var value: u8 = 0;

        if (c >= '0' and c <= '9') {
            value = @intCast(u8, c - '0');
        } else if (is_last and c == 'X') {
            value = 10;
        } else {
            return false;
        }

        const weight = 10 - @intCast(u8, pos);
        sum += @intCast(u32, value) * @intCast(u32, weight);
        pos += 1;
    }

    if (pos != 10) return false;
    return (sum % 11) == 0;
}
