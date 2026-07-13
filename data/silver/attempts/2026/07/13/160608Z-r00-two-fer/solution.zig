pub fn twoFer(buffer: []u8, name: ?[]const u8) ![]u8 {
    const base = "One for ";
    const suffix = ", one for me.";

    const base_len: usize = 8;
    const suffix_len: usize = 11;

    const name_len: usize = if (name) != null {
        name.len
    } else {
        3 // "you"
    };

    const total_len = base_len + name_len + suffix_len;
    if (total_len > buffer.len) {
        return error "buffer too small";
    }

    var i: usize = 0;

    // write base
    for (base) |c| {
        buffer[i] = c;
        i += 1;
    }

    // write name or "you"
    if (name) != null {
        for (name) |c| {
            buffer[i] = c;
            i += 1;
        }
    } else {
        const you = ['y', 'o', 'u'];
        for (you) |c| {
            buffer[i] = c;
            i += 1;
        }
    }

    // write suffix
    for (suffix) |c| {
        buffer[i] = c;
        i += 1;
    }

    return buffer[0:i];
}
