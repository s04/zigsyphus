/// Returns the number of rectangles in the ASCII diagram `strings`.
pub fn rectangles(strings: []const []const u8) usize {
    const rows = strings.len;
    if (rows == 0) return 0;
    const cols = strings[0].len;
    if (cols == 0) return 0;

    var count: usize = 0;

    // Find all '+' positions
    var plus_positions: []std.ArrayList(struct { row: usize, col: usize }) = undefined;
    // We'll just iterate through all possible corner pairs

    for (0..rows) |r1| {
        for (0..cols) |c1| {
            if (strings[r1][c1] != '+') continue;
            // c1 is top-left corner column
            for (c1 + 1..cols) |c2| {
                if (strings[r1][c2] != '+') continue;
                // Check top edge from c1 to c2
                var top_ok = true;
                for (c1 + 1..c2) |c| {
                    const ch = strings[r1][c];
                    if (ch != '-' && ch != '+') {
                        top_ok = false;
                        break;
                    }
                }
                if (!top_ok) continue;

                // c2 is top-right corner column, now look for bottom corners
                for (r1 + 1..rows) |r2| {
                    if (strings[r2][c1] != '+') continue;
                    if (strings[r2][c2] != '+') continue;

                    // Check bottom edge
                    var bottom_ok = true;
                    for (c1 + 1..c2) |c| {
                        const ch = strings[r2][c];
                        if (ch != '-' && ch != '+') {
                            bottom_ok = false;
                            break;
                        }
                    }
                    if (!bottom_ok) continue;

                    // Check left edge
                    var left_ok = true;
                    for (r1 + 1..r2) |r| {
                        const ch = strings[r][c1];
                        if (ch != '|' && ch != '+') {
                            left_ok = false;
                            break;
                        }
                    }
                    if (!left_ok) continue;

                    // Check right edge
                    var right_ok = true;
                    for (r1 + 1..r2) |r| {
                        const ch = strings[r][c2];
                        if (ch != '|' && ch != '+') {
                            right_ok = false;
                            break;
                        }
                    }
                    if (!right_ok) continue;

                    count += 1;
                }
            }
        }
    }

    return count;
}
