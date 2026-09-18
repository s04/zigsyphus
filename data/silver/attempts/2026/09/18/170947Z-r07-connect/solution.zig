const std = @import("std");
const mem = std.mem;

pub fn winner(allocator: mem.Allocator, board: []const []const u8) mem.Allocator.Error!u8 {
    if (board.len == 0) {
        return '.';
    }
    const rows = board.len;
    // compute width from first row (count non-space bytes)
    var width: usize = 0;
    for (board[0]) |b| {
        if (b != ' ') {
            width += 1;
        }
    }
    if (width == 0) {
        return '.';
    }
    // allocate visited and queue arrays
    var visited = try allocator.alloc(bool, rows * width);
    defer allocator.free(visited);
    var queue = try allocator.alloc(usize, rows * width);
    defer allocator.free(queue);
    // helper to reset visited array
    fn resetVisited(visited: []bool, len: usize) void {
        std.mem.setBytes(visited, 0);
    }
    // BFS to check if player connects their sides
    fn connects(board: []const []const u8, rows: usize, width: usize, player: u8, visited: []bool, queue: []usize) bool {
        resetVisited(visited, rows * width);
        var head: usize = 0;
        var tail: usize = 0;
        const start_is_edge = if (player == 'O') fn (r: usize, c: usize) bool { return r == 0; } else fn (r: usize, c: usize) bool { return c == 0; };
        const is_target = if (player == 'O') fn (r: usize, c: usize) bool { return r == rows - 1; } else fn (r: usize, c: usize) bool { return c == width - 1; };
        // enqueue all start cells of the player
        for (rows) |r| {
            for (width) |c| {
                if (board[r][r + c * 2] == player) {
                    if (start_is_edge(r, c)) {
                        const idx = r * width + c;
                        if (!visited[idx]) {
                            visited[idx] = true;
                            queue[tail++] = idx;
                        }
                    }
                }
            }
        }
        // neighbor offsets: up-left, up-right, left, right, down-left, down-right
        const offsets = [_][2]i32{
            .{-1, 0},
            .{-1, 1},
            .{0, -1},
            .{0, +1},
            .{1, -1},
            .{1, 0},
        };
        const rows_is = @intCast(isize, rows);
        const width_is = @intCast(isize, width);
        while (head < tail) {
            const idx = queue[head++];
            const r = @intCast(isize, idx / width);
            const c = @intCast(isize, idx % width);
            if (is_target(@intCast(usize, r), @intCast(usize, c))) {
                return true;
            }
            for (offsets) |off| {
                const nr = r + off[0];
                const nc = c + off[1];
                if (nr >= 0 && nr < rows_is && nc >= 0 && nc < width_is) {
                    const nr_us = @intCast(usize, nr);
                    const nc_us = @intCast(usize, nc);
                    const nidx = nr_us * width + nc_us;
                    if (!visited[nidx] && board[nr_us][nr_us + nc_us * 2] == player) {
                        visited[nidx] = true;
                        queue[tail++] = nidx;
                    }
                }
            }
        }
        return false;
    }
    const player_O = u8('O');
    const player_X = u8('X');
    if (connects(board, rows, width, player_O, visited, queue)) {
        return 'O';
    }
    if (connects(board, rows, width, player_X, visited, queue)) {
        return 'X';
    }
    return '.';
}
