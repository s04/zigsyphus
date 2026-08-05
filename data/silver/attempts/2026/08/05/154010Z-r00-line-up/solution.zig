const std = @import("std");
const mem = std.mem;

pub fn format(allocator: mem.Allocator, name: []const u8, number: u10) ![]u8 {
    const suffix = blk: {
        const last_two = number % 100;
        if (last_two >= 11 and last_two <= 13) {
            break :blk "th";
        }
        const last_digit = number % 10;
        if (last_digit == 1) {
            break :blk "st";
        } else if (last_digit == 2) {
            break :blk "nd";
        } else if (last_digit == 3) {
            break :blk "rd";
        } else {
            break :blk "th";
        }
    };

    return std.fmt.allocPrint(allocator, "{s}, you are the {d}{s} customer we serve today. Thank you!", .{ name, number, suffix });
}
