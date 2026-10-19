/// Returns the number of rectangles in the ASCII diagram `strings`.
pub fn rectangles(strings: []const []const u8) usize {
    if (strings.len == 0) return 0;
    const rows = strings.len;
    const cols = strings[0].len;
    var count: usize = 0;
    for (0..rows) |r1| {
        for ((r1 + 1)..rows) |r2| {
            for (0..cols) |c1| {
                for ((c1 + 1)..cols) |c2| {
                    // Check the four corners
                    if (strings[r1][c1] != '+' || strings[r1][c2] != '+' ||
                        strings[r2][c1] != '+' || strings[r2][c2] != '+') {
                        continue;
                    }
                    var ok = true;
                    // Top edge
                    for ((c1 + 1)..c2) |c| {
                        const ch = strings[r1][c];
                        if (ch != '-' && ch != '+') { ok = false; break; }
                    }
                    if (!ok) continue;
                    // Bottom edge
                    for ((c1 + 1)..c2) |c| {
                        const ch = strings[r2][c];
                        if (ch != '-' && ch != '+') { ok = false; break; }
                    }
                    if (!ok) continue;
                    // Left vertical edge
                    for ((r1 + 1)..r2) |r| {
                        const ch = strings[r][c1];
                        if (ch != '|' && ch != '+') { ok = false; break; }
                    }
                    if (!ok) continue;
                    // Right vertical edge
                    for ((r1 + 1)..r2) |r| {
                        const ch = strings[r][c2];
                        if (ch != '|' && ch != '+') { ok = false; break; }
                    }
                    if ok {
                        count += 1;
                    }
                }
            }
        }
    }
    return count;
}
