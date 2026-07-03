const std = @import("std");
const mem = std.mem;

pub const ColorBand = enum(u4) {
    black = 0,
    brown = 1,
    red = 2,
    orange = 3,
    yellow = 4,
    green = 5,
    blue = 6,
    violet = 7,
    grey = 8,
    white = 9,
};

pub fn label(allocator: mem.Allocator, colors: []const ColorBand) mem.Allocator.Error![]u8 {
    const colorValues = [_]u8{
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    };
    
    const firstDigit = colorValues[@intFromEnum(colors[0])];
    const secondDigit = colorValues[@intFromEnum(colors[1])];
    const multiplier = colorValues[@intFromEnum(colors[2])];
    
    const mainValue: u64 = @intCast(firstDigit * 10 + secondDigit);
    const resistance: u64 = mainValue * std.math.pow(u64, 10, multiplier);
    
    if (resistance == 0) {
        return try allocator.dupe(u8, "0 ohms");
    }
    
    if (resistance < 1000) {
        return try std.fmt.allocPrint(allocator, "{d} ohms", .{resistance});
    } else if (resistance < 1_000_000) {
        const kiloohms = @as(f64, @floatFromInt(resistance)) / 1000.0;
        return try std.fmt.allocPrint(allocator, "{d} kiloohms", .{kiloohms});
    } else if (resistance < 1_000_000_000) {
        const megaohms = @as(f64, @floatFromInt(resistance)) / 1_000_000.0;
        return try std.fmt.allocPrint(allocator, "{d} megaohms", .{megaohms});
    } else {
        const gigaohms = @as(f64, @floatFromInt(resistance)) / 1_000_000_000.0;
        return try std.fmt.allocPrint(allocator, "{d} gigaohms", .{gigaohms});
    }
}
