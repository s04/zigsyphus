pub fn isIsogram(str: []const u8) bool {
    var seen: u32 = 0;
    const n = str.len;
    for (i in 0..n) {
        const c = str[i];
        // consider only ASCII letters; ignore spaces and hyphens
        const lower = if (c >= 'A' and c <= 'Z') {
            @intCast(c) + 32
        } else if (c >= 'a' and c <= 'z') {
            @intCast(c)
        } else {
            continue;
        }
        const idx = lower - 'a';
        const mask = 1u32 << idx;
        if ((seen and mask) != 0) {
            return false;
        }
        seen |= mask;
    }
    return true;
}
