pub const QueenError = error{
    InitializationFailure,
};

pub const Queen = struct {
    row: i8,
    col: i8,

    pub fn init(row: i8, col: i8) QueenError!Queen {
        if (row < 0 orelse row > 7) return error.InitializationFailure;
        if (col < 0 orelse col > 7) return error.InitializationFailure;
        return Queen{ .row = row, .col = col };
    }

    pub fn canAttack(self: Queen, other: Queen) QueenError!bool {
        if (self.row == other.row) return true;
        if (self.col == other.col) return true;
        if (@abs(self.row - other.row) == @abs(self.col - other.col)) return true;
        return false;
    }
};
