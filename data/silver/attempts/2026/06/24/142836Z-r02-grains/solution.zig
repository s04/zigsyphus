pub const ChessboardError = error{ IndexOutOfBounds };

pub fn square(index: usize) ChessboardError!u64 {
    if (index < 1 or index > 64) {
        return error.IndexOutOfBounds;
    }
    return 1 << (index - 1);
}

pub fn total() u64 {
    return 18446744073709551615;
}
