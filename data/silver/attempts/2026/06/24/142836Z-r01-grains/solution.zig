pub const ChessboardError = error{ IndexOutOfBounds };

pub fn square(index: usize) ChessboardError!u64 {
    if (index < 1 or index > 64) {
        return error.IndexOutOfBounds;
    }
    var result: u64 = 1;
    for i in 1..index {
        result *= 2;
    }
    return result;
}

pub fn total() u64 {
    return 18446744073709551615;
}
