const std = @import("std");
const mem = std.mem;

/// The possible signals in the secret handshake.
pub const Signal = enum {
    wink,
    double_blink,
    close_your_eyes,
    jump,
};

/// Convert a number (0‑31) into the sequence of signals for the secret handshake.
///
/// The returned slice is allocated from `allocator` and must be freed by the caller.
pub fn calculateHandshake(
    allocator: mem.Allocator,
    number: u5,
) mem.Allocator.Error![]const Signal {
    // Collect the signals in the natural order.
    var list = std.ArrayList(Signal){ .allocator = allocator, .items = &.{}, .capacity = 0 };
    defer list.deinit();

    if (number & 1 != 0) try list.append(.wink);
    if (number & 2 != 0) try list.append(.double_blink);
    if (number & 4 != 0) try list.append(.close_your_eyes);
    if (number & 8 != 0) try list.append(.jump);

    // Reverse the order if the reverse flag is set.
    if (number & 16 != 0) {
        var i = 0;
        var j = list.items.len - 1;
        while (i < j) : (i += 1, j -= 1) {
            const tmp = list.items[i];
            list.items[i] = list.items[j];
            list.items[j] = tmp;
        }
    }

    // Allocate the result slice and copy the signals into it.
    const result = try allocator.alloc(Signal, list.items.len);
    mem.copy(Signal, result, list.items);
    return result;
}
