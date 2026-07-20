pub const ColorBand = enum {
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
    return @intCast(@intFromEnum(color));
}

pub fn colors() []const ColorBand {
    const arr = [_]ColorBand{
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
    return arr[0..];
}
