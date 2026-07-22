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

pub fn label(allocator: mem.Allocator, colors: []const ColorBand)![]u8 {
    _ = allocator;
    _ = colors;

    const v1 = _value(colors[0]);
    const v2 = _value(colors[1]);
    const v3 = _value(colors[2]);

    var val: f64 = @floatFromInt(v1 * 10 + v2);
    for (0..v3) |_| {
        val *= 10.0;
    }

    const units = [_]struct { name: []const u8, factor: f64 }{
        .{ "gigaohms", 1.0e9 },
        .{ "megaohms", 1.0e6 },
        .{ "kiloohms", 1.0e3 },
        .{ "ohms", 1.0 },
    };

    var unit_idx: usize = 3;
    for (0..units.len) |i| {
        if (val >= units[i].factor - 0.000001) {
            unit_idx = i;
            break;
        }
    }

    const scaled = val / units[unit_idx].factor;
    
    const epsilon = 0.000001;
    const diff = @abs(scaled - @round(scaled));
    
    if (diff < epsilon) {
        const int_val = @as(i64, @intFromFloat(@round(scaled)));
        return try std.fmt.allocPrint(allocator, "{d} {s}", .{ int_val, units[unit_idx].name });
    } else {
        return try std.fmt.allocPrint(allocator, "{d:.1} {s}", .{ scaled, units[unit_idx].name });
    }
}

fn _value(c: ColorBand) u32 {
    return switch (c) {
        ColorBand.black => 0,
        ColorBand.brown => 1,
        ColorBand.red => 2,
        ColorBand.orange => 3,
        ColorBand.yellow => 4,
        ColorBand.green => 5,
        ColorBand.blue => 6,
        ColorBand.violet => 7,
        ColorBand.grey => 8,
        ColorBand.white => 9,
    };
}
