const std = @import("std");
const mem = std.mem;

fn ordinalSuffix(number: u10) []const u8 {
    const n = @intCast(number);
    const last_two = n % 100;
    if (last_two >= 11 && last_two <= 13) {
        return "th";
    }
    return switch (n % 10) {
        1 => "st",
        2 => "nd",
        3 => "rd",
        else => "th",
    };
}

pub fn format(allocator: mem.Allocator, name: []const u8, number: u10) ![]u8 {
    const suffix = ordinalSuffix(number);
    return try std.fmt.allocPrint(allocator, "{s}, you are the {d}{s} customer we serve today. Thank you!", .{name, number, suffix});
}
