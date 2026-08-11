pub fn modifier(score: i8) i8 {
    var s = score - 10;
    // floor division by 2
    if (s < 0 and s % 2 != 0) {
        return @as(i8, s / 2 - 1);
    }
    return @as(i8, s / 2);
}
