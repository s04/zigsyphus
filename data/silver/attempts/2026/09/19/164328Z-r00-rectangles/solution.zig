fn isHorizontal(strings: []const []const u8, row: usize, left: usize, right: usize) bool {
    var column = left + 1;
    while (column < right) : (column += 1) {
        const character = strings[row][column];
        if (character != '-' and character != '+') {
            return false;
        }
    }
    return true;
}

fn isVertical(strings: []const []const u8, top: usize, bottom: usize, column: usize) bool {
    var row = top + 1;
    while (row < bottom) : (row += 1) {
        const character = strings[row][column];
        if (character != '|' and character != '+') {
            return false;
        }
    }
    return true;
}

/// Returns the number of rectangles in the ASCII diagram `strings`.
pub fn rectangles(strings: []const []const u8) usize {
    const rows = strings.len;
    if (rows == 0) {
        return 0;
    }

    const columns = strings[0].len;
    if (columns == 0) {
        return 0;
    }

    var count: usize = 0;
    var top: usize = 0;
    while (top < rows) : (top += 1) {
        var left: usize = 0;
        while (left < columns) : (left += 1) {
            if (strings[top][left] != '+') {
                continue;
            }

            var right = left + 1;
            while (right < columns) : (right += 1) {
                if (strings[top][right] != '+') {
                    continue;
                }

                var bottom = top + 1;
                while (bottom < rows) : (bottom += 1) {
                    if (strings[bottom][left] != '+' or strings[bottom][right] != '+') {
                        continue;
                    }

                    if (isHorizontal(strings, top, left, right) and
                        isHorizontal(strings, bottom, left, right) and
                        isVertical(strings, top, bottom, left) and
                        isVertical(strings, top, bottom, right))
                    {
                        count += 1;
                    }
                }
            }
        }
    }

    return count;
}
