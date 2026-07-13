pub fn twoFer(buffer: []u8, name: ?[]const u8) ![]u8 {
    const base = "One for ";
    const suffix = ", one for me.";

    const name_str = if (name) |n| n else "you";

    const base_len = base.len;
    const name_len = name_str.len;
    const suffix_len = suffix.len;

    const total_len = base_len + name_len + suffix_len;

    if (total_len > buffer.len) {
        return error.BufferTooSmall;
    }

    var i: usize = 0;

    // Copy base
    for (base) |c| {
        buffer[i] = c;
        i += 1;
    }

    // Copy name or "you"
    for (name_str) |c| {
        buffer[i] = c;
        i += 1;
    }

    // Copy suffix
    for (suffix) |c| {
        buffer[i] = c;
        i += 1;
    }

    return buffer[0..i];
}
