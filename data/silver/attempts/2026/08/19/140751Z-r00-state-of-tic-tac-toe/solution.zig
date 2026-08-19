pub const GameState = enum {
    win,
    draw,
    ongoing,
    impossible,
};

pub fn gameState(board: []const []const u8) GameState {
    // Count X's and O's
    var x_count: u8 = 0;
    var o_count: u8 = 0;
    
    for (board) |row| {
        for (row) |cell| {
            switch (cell) {
                'X' => x_count += 1,
                'O' => o_count += 1,
                ' ' => {},
                else => return GameState.impossible,
            }
        }
    }
    
    // Check turn order validity
    if (o_count > x_count) return GameState.impossible;  // O started
    if (x_count > o_count + 1) return GameState.impossible;  // X went twice
    
    // Check for wins
    var x_won = false;
    var o_won = false;
    
    // Check rows
    for (board) |row| {
        if (row[0] == 'X' and row[1] == 'X' and row[2] == 'X') x_won = true;
        if (row[0] == 'O' and row[1] == 'O' and row[2] == 'O') o_won = true;
    }
    
    // Check columns
    for (0..3) |col| {
        if (board[0][col] == 'X' and board[1][col] == 'X' and board[2][col] == 'X') x_won = true;
        if (board[0][col] == 'O' and board[1][col] == 'O' and board[2][col] == 'O') o_won = true;
    }
    
    // Check diagonals
    if (board[0][0] == 'X' and board[1][1] == 'X' and board[2][2] == 'X') x_won = true;
    if (board[0][2] == 'X' and board[1][1] == 'X' and board[2][0] == 'X') x_won = true;
    if (board[0][0] == 'O' and board[1][1] == 'O' and board[2][2] == 'O') o_won = true;
    if (board[0][2] == 'O' and board[1][1] == 'O' and board[2][0] == 'O') o_won = true;
    
    // Both can't win
    if (x_won and o_won) return GameState.impossible;
    
    // Validate win conditions with turn counts
    if (x_won) {
        // X must have just played, so X count = O count + 1
        if (x_count != o_count + 1) return GameState.impossible;
        return GameState.win;
    }
    
    if (o_won) {
        // O must have just played, so X count = O count
        if (x_count != o_count) return GameState.impossible;
        return GameState.win;
    }
    
    // No winner
    if (x_count + o_count == 9) {
        return GameState.draw;
    }
    
    return GameState.ongoing;
}
