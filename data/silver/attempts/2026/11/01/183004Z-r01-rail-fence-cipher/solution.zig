const std = @import("std");
const mem = std.mem;

pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const len = msg.len;
    if (len == 0 or rails <= 1) {
        const result = try allocator.alloc(u8, len);
        for (msg, 0..) |c, i| {
            result[i] = c;
        }
        return result;
    }

    const nRails = @intCast(usize, rails);
    const rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (0..nRails) |i| {
        rowLengths[i] = 0;
    }

    var row: usize = 0;
    var goingDown: bool = true;
    for (msg) |_| {
        rowLengths[row] += 1;
        if (goingDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            goingDown = true;
        } else if (row == nRails - 1) {
            goingDown = false;
        }
    }

    const rowStarts = try allocator.alloc(usize, nRails);
    defer allocator.free(rowStarts);
    var sum: usize = 0;
    for (0..nRails) |i| {
        rowStarts[i] = sum;
        sum += rowLengths[i];
    }

    const result = try allocator.alloc(u8, len);
    const rowCounters = try allocator.alloc(usize, nRails);
    defer allocator.free(rowCounters);
    for (0..nRails) |i| {
        rowCounters[i] = 0;
    }

    row = 0;
    goingDown = true;
    for (msg) |c| {
        const r = row;
        const cnt = rowCounters[r];
        result[rowStarts[r] + cnt] = c;
        rowCounters[r] = cnt + 1;

        if (goingDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            goingDown = true;
        } else if (row == nRails - 1) {
            goingDown = false;
        }
    }

    return result;
}

pub fn decode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const len = msg.len;
    if (len == 0 or rails <= 1) {
        const result = try allocator.alloc(u8, len);
        for (msg, 0..) |c, i| {
            result[i] = c;
        }
        return result;
    }

    const nRails = @intCast(usize, rails);
    const rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (0..nRails) |i| {
        rowLengths[i] = 0;
    }

    var row: usize = 0;
    var goingDown: bool = true;
    for (msg) |_| {
        rowLengths[row] += 1;
        if (goingDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            goingDown = true;
        } else if (row == nRails - 1) {
            goingDown = false;
        }
    }

    const rowStarts = try allocator.alloc(usize, nRails);
    defer allocator.free(rowStarts);
    var sum: usize = 0;
    for (0..nRails) |i| {
        rowStarts[i] = sum;
        sum += rowLengths[i];
    }

    const result = try allocator.alloc(u8, len);
    const rowCounters = try allocator.alloc(usize, nRails);
    defer allocator.free(rowCounters);
    for (0..nRails) |i| {
        rowCounters[i] = 0;
    }

    row = 0;
    goingDown = true;
    for (0..len) |i| {
        const r = row;
        const cnt = rowCounters[r];
        result[i] = msg[rowStarts[r] + cnt];
        rowCounters[r] = cnt + 1;

        if (goingDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            goingDown = true;
        } else if (row == nRails - 1) {
            goingDown = false;
        }
    }

    return result;
}
