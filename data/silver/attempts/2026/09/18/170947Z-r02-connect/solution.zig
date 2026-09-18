const std = @import("std");
const mem = std.mem;

pub fn winner(allocator: mem.Allocator, board: []const []const u8) !u8 {
    if (board.len == 0) {
        return '.';
    }

    // Parse board into rows of cells (ignore spaces)
    var rows = try allocator.alloc([]u8, board.len);
    defer allocator.free(rows);
    for (board) |row_str, i| {
        var len: usize = 0;
        for (row_str) |c| {
            if (c != ' ') len += 1;
        }
        var row = try allocator.alloc(u8, len);
        defer allocator.free(row);
        var j: usize = 0;
        for (row_str) |c| {
            if (c != ' ') {
                row[j] = c;
                j += 1;
            }
        }
        rows[i] = row;
    }

    // Helper to free rows on early return
    fn freeRows(allocator: mem.Allocator, rows: [][]u8) void {
        for (rows) |row| {
            allocator.free(row);
        }
        allocator.free(rows);
    }

    // Check O connection (top to bottom)
    if (try connects(allocator, rows, 'O', .top_bottom)) {
        freeRows(allocator, rows);
        return 'O';
    }
    // Check X connection (left to right)
    if (try connects(allocator, rows, 'X', .left_right)) {
        freeRows(allocator, rows);
        return 'X';
    }
    freeRows(allocator, rows);
    return '.';
}

const ConnectionKind = enum { top_bottom, left_right };

fn connects(allocator: mem.Allocator, board: [][]const u8, player: u8, kind: ConnectionKind) !bool {
    const row_count = board.len;
    if (row_count == 0) return false;

    // Allocate visited matrix matching board shape
    var visited = try allocator.alloc([]bool, row_count);
    defer allocator.free(visited);
    for (visited) |vis_row, i| {
        vis_row.* = try allocator.alloc(bool, board[i].len);
        defer allocator.free(vis_row.*);
        std.mem.setBytes(vis_row.*, 0);
    }

    var queue = std.ArrayList(struct { r: usize; c: usize }).init(allocator);
    defer queue.deinit();

    // Initialize queue with start cells
    switch (kind) {
        .top_bottom => {
            // top row (r = 0)
            const top_row = board[0];
            for (top_row) |cell, c| {
                if (cell == player) {
                    visited[0][c] = true;
                    try queue.append(.{ .r = 0, .c = c });
                }
            }
        }
        .left_right => {
            // left column (c = 0) for each row
            for (board) |row, r| {
                if (row.len > 0 && row[0] == player) {
                    visited[r][0] = true;
                    try queue.append(.{ .r = r, .c = 0 });
                }
            }
        }
    }

    while (queue.items.len > 0) {
        const pos = queue.pop() orelse unreachable;
        const r = pos.r;
        const c = pos.c;

        // Check if reached target edge
        switch (kind) {
            .top_bottom => {
                if (r == row_count - 1) {
                    return true;
                }
            }
            .left_right => {
                if (c == board[r].len - 1) {
                    return true;
                }
            }
        }

        // Determine neighbor offsets based on row parity
        const r_is = @intCast(isize, r);
        const c_is = @intCast(isize, c);
        const offsets = if (r % 2 == 0) |_| {
            // even row
            [_]struct { dr: isize; dc: isize }{
                .{ dr =  0, dc = -1 }, // left
                .{ dr =  0, dc =  1 }, // right
                .{ dr = -1, dc = -1 }, // upper-left
                .{ dr = -1, dc =  0 }, // upper-right
                .{ dr =  1, dc = -1 }, // lower-left
                .{ dr =  1, dc =  0 }, // lower-right
            };
        } else |_| {
            // odd row
            [_]struct { dr: isize; dc: isize }{
                .{ dr =  0, dc = -1 }, // left
                .{ dr =  0, dc =  1 }, // right
                .{ dr = -1, dc =  0 }, // upper-left
                .{ dr = -1, dc =  1 }, // upper-right
                .{ dr =  1, dc =  0 }, // lower-left
                .{ dr =  1, dc =  1 }, // lower-right
            };
        };

        for (offsets) |offset| {
            const nr = r_is + offset.dr;
            const nc = c_is + offset.dc;
            if (nr < 0 || nr >= @intCast(isize, row_count)) continue;
            const nrow = board[@intCast(usize, nr)];
            if (nc < 0 || nc >= @intCast(isize, nrow.len)) continue;
            const nru = @intCast(usize, nr);
            const ncu = @intCast(usize, nc);
            if (visited[nru][ncu]) continue;
            if (nrow[ncu] != player) continue;
            visited[nru][ncu] = true;
            try queue.append(.{ .r = nru, .c = ncu });
        }
    }

    return false;
}
