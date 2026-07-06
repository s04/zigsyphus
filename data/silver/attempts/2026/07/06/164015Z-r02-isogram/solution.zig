pub fn isIsogram(str: []const u8) bool {
    var seen: u32 = 0;
    const n = str.len;
    for (0..n) |i| {
        const c = str[i];
        var lower: u8 = 0;
        if (c >= 'A' and c <= 'Z') {
            lower = c + 32;
        } else if (c >= 'a' and c <= 'z') {
            lower = c;
        } else {
            continue;
        }
        const idx = lower - 'a';
        const mask = u32(1) << idx;
        if ((seen and mask) != 0) {
            return false;
        }
        seen |= mask;
    }
    return true;
}
