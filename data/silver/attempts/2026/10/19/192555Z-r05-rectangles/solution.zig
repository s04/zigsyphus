/// Returns the number of rectangles in the ASCII diagram `strings`.
pub fn rectangles(strings: []const []const u8) usize {
    const rows = strings.len;
    if (rows == 0) return 0;
    const cols = strings[0].len;
    if (cols == 0) return 0;

    var count: usize = 0;

    var left: usize = 0;
    while (left < cols) : (left += 1) {
        var right: usize = left + 1;
        while (right < cols) : (right += 1) {
            var top: usize = 0;
            while (top < rows) : (top += 1) {
                if (strings[top][left] == '+' and strings[top][right] == '+') {
                    var bottom: usize = top + 1;
                    while (bottom < rows) : (bottom += 1) {
                        if (strings[bottom][left] == '+' and strings[bottom][right] == '+') {
                            // Check top edge
                            var ok = true;
                            var c: usize = left + 1;
                            while (c < right) : (c += 1) {
                                const ch = strings[top][c];
                                if (ch != '-' and ch != '+') {
                                    ok = false;
                                    break;
                                }
                            }
                            if (!ok) continue;
                            // Check bottom edge
                            c = left + 1;
                            while (c < right) : (c += 1) {
                                const ch = strings[bottom][c];
                                if (ch != '-' and ch != '+') {
                                    ok = false;
                                    break;
                                }
                            }
                            if (!ok) continue;
                            // Check left edge
                            var r: usize = top + 1;
                            while (r < bottom) : (r += 1) {
                                const ch = strings[r][left];
                                if (ch != '|' and ch != '+') {
                                    ok = false;
                                    break;
                                }
                            }
                            if (!ok) continue;
                            // Check right edge
                            r = top + 1;
                            while (r < bottom) : (r += 1) {
                                const ch = strings[r][right];
                                if (ch != '|' and ch != '+') {
                                    ok = false;
                                    break;
                                }
                            }
                            if (!ok) continue;
                            count += 1;
                        }
                    }
                }
            }
        }
    }

    return count;
}
