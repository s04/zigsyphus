const std = @import("std");
const mem = std.mem;

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

pub fn label(allocator: mem.Allocator, colors: []const ColorBand) mem.Allocator.Error![]u8 {
    if (colors.len < 3) {
        // Fallback – the problem guarantees at least three colors.
        return allocator.dupe("0 ohms");
    }

    fn colorToValue(c: ColorBand) u32 {
        return switch (c) {
            .black => 0,
            .brown => 1,
            .red => 2,
            .orange => 3,
            .yellow => 4,
            .green => 5,
            .blue => 6,
            .violet => 7,
            .grey => 8,
            .white => 9,
        };
    }

    const first = colorToValue(colors[0]);
    const second = colorToValue(colors[1]);
    const third = colorToValue(colors[2]);

    const main: u32 = first * 10 + second;
    const multiplier: u32 = third;

    // Compute resistance value: main * 10^multiplier
    var value: u64 = @intCast(main);
    var pow: u64 = 1;
    var i: u32 = 0;
    while (i < multiplier) : (i += 1) {
        pow *= 10;
    }
    value *= pow;

    if (value == 0) {
        return allocator.dupe("0 ohms");
    }

    const factors = [_]struct { name: []const u8, factor: u64 }{
        .{ .name = "gigaohms", .factor = 1_000_000_000 },
        .{ .name = "megaohms", .factor = 1_000_000 },
        .{ .name = "kiloohms", .factor = 1_000 },
        .{ .name = "ohms", .factor = 1 },
    };

    var chosen: ?struct { name: []const u8, factor: u64 } = null;
    for (factors) |f| {
        if (value >= f.factor) {
            chosen = .{ .name = f.name, .factor = f.factor };
            break;
        }
    }
    if (chosen == null) {
        chosen = .{ .name = "ohms", .factor = 1 };
    }

    const quot = value / chosen.factor;
    const rem = value % chosen.factor;

    var buf: [32]u8 = undefined;
    var pos: usize = 0;
    if (rem == 0) {
        pos = std.fmt.bufPrint(&buf, "{d} {s}", .{ quot, chosen.name }) orelse unreachable;
    } else {
        const tenth = (rem * 10) / chosen.factor;
        pos = std.fmt.bufPrint(&buf, "{d}.{d} {s}", .{ quot, tenth, chosen.name }) orelse unreachable;
    }

    return allocator.dupe(buf[0..pos]);
}
