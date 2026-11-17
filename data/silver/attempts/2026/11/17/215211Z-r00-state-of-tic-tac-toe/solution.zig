pub const GameState = enum {
    win,
    draw,
    ongoing,
    impossible,
};

pub fn gameState(board: []const []const u8) GameState {
    var count_x: usize = 0;
    var count_o: usize = 0;
    for (board) |row| {
        for (row) |cell| {
            switch (cell) {
                'X' => count_x += 1,
                'O' => count_o += 1,
                ' ' => {},
                else => return GameState.impossible,
            }
        }
    }

    // X starts, so X must have either the same count as O or exactly one more.
    if (count_x != count_o and count_x != count_o + 1) {
        return GameState.impossible;
    }

    const x_won = hasWon(board, 'X');
    const o_won = hasWon(board, 'O');

    // Both players cannot win.
    if (x_won and o_won) {
        return GameState.impossible;
    }

    if (x_won) {
        // X wins on its own turn, so X must have one more mark than O.
        if (count_x != count_o + 1) {
            return GameState.impossible;
        }
        return GameState.win;
    }

    if (o_won) {
        // O wins on its own turn, so the counts must be equal.
        if (count_x != count_o) {
            return GameState.impossible;
        }
        return GameState.win;
    }

    if (count_x + count_o == 9) {
        return GameState.draw;
    }

    return GameState.ongoing;
}

fn hasWon(board: []const []const u8, player: u8) bool {
    if (board.len < 3) {
        return false;
    }
    for (0..3) |i| {
        if (board[i].len >= 3) {
            if (board[i][0] == player and board[i][1] == player and board[i][2] == player) {
                return true;
            }
        }
        if (board[0].len > i and board[1].len > i and board[2].len > i) {
            if (board[0][i] == player and board[1][i] == player and board[2][i] == player) {
                return true;
            }
        }
    }
    if (board[0].len >= 3 and board[1].len >= 3 and board[2].len >= 3) {
        if (board[0][0] == player and board[1][1] == player and board[2][2] == player) {
            return true;
        }
        if (board[0][2] == player and board[1][1] == player and board[2][0] == player) {
            return true;
        }
    }
    return false;
}
