pub fn eggCount(number: usize) usize {
    var count: usize = 0;
    var n: usize = number;
    while n != 0 {
        n = n & (n - 1);
        count += 1;
    }
    return count;
}
