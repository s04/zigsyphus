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

pub fn label(allocator: mem.Allocator, colors: []const ColorBand) ![]u8 {
    // Ensure at least 3 colors, ignore any extras
    if (colors.len < 3) {
        const s = try std.fmt.allocPrint(allocator, "0 ohms");
        return s;
    }

    const v1 = _value(colors[0]);
    const v2 = _value(colors[1]);
    const v3 = _value(colors[2]);

    // Compute the numeric value as f64
    var val: f64 = @f64(v1 * 10 + v2);
    for (0..v3) {
        val *= 10.0;
    }

    // Define units and their factors
    const units = [_]struct {
        name: []const u8,
        factor: f64,
    }{
        { "gigaohms", 1.0e9 },
        { "megaohms", 1.0e6 },
        { "kiloohms", 1.0e3 },
        { "ohms", 1.0 },
    };

    // Find appropriate unit
    var unit_idx: usize = 3; // default ohms
    for (0..4) |i| {
        if (val >= units[i].factor) {
            unit_idx = i;
            break;
        }
    }

    const scaled = val / units[unit_idx].factor;
    const is_int = @abs(scaled - @round(scaled)) < 0.000001;

    // Build result string
    if (is_int) {
        const int_val = @as(f64, @round(scaled));
        const result = try std.fmt.allocPrint(allocator, "{d} {s}",.{ int_val, units[unit_idx].name });
        return result;
    } else {
        const result = try std.fmt.allocPrint(allocator, "{d:.1} {s}",.{ scaled, units[unit_idx].name });
        return result;
    }
}

// Helper to get numeric value of a color band
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
