const ColorBand = enum {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

pub fn colorCode(color: ColorBand) usize {
    return @as(usize, @intCast(color));
}

pub fn colors() []const ColorBand {
    return [_]ColorBand{
        .black,
        .brown,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .violet,
        .grey,
        .white,
    };
}
