pub fn eggCount(number: usize) usize {
    var count: usize = 0;
    var n = number;
    while (n != 0) : (n >>= 1) {
        if ((n & 1) != 0) {
            count += 1;
        }
    }
    return count;
}
