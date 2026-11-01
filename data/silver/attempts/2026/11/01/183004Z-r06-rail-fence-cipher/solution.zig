const std = @import("std");
const mem = std.mem;

/// Encodes `msg` using the rail fence cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const nRails: usize = @intCast(rails);
    const len = msg.len;
    if (len == 0 or nRails <= 1) {
        const result = try allocator.alloc(u8, len);
        mem.copyForwards(result, msg);
        return result;
    }

    var rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (0..nRails) |i| rowLengths[i] = 0;

    var row: usize = 0;
    var dirDown: bool = true;
    for (0..len) |_| {
        rowLengths[row] += 1;
        if (dirDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            dirDown = true;
        } else if (row == nRails - 1) {
            dirDown = false;
        }
    }

    var rowStarts = try allocator.alloc(usize, nRails);
    defer allocator.free(rowStarts);
    var sum: usize = 0;
    for (0..nRails) |i| {
        rowStarts[i] = sum;
        sum += rowLengths[i];
    }

    var counters = try allocator.alloc(usize, nRails);
    defer allocator.free(counters);
    for (0..nRails) |i| counters[i] = 0;

    var result = try allocator.alloc(u8, len);
    row = 0;
    dirDown = true;
    for (msg) |c| {
        const r = row;
        result[rowStarts[r] + counters[r]] = c;
        counters[r] += 1;

        if (dirDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            dirDown = true;
        } else if (row == nRails - 1) {
            dirDown = false;
        }
    }

    return result;
}

/// Decodes `msg` using the rail fence cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const nRails: usize = @intCast(rails);
    const len = msg.len;
    if (len == 0 or nRails <= 1) {
        const result = try allocator.alloc(u8, len);
        mem.copyForwards(result, msg);
        return result;
    }

    var rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (0..nRails) |i| rowLengths[i] = 0;

    var row: usize = 0;
    var dirDown: bool = true;
    for (0..len) |_| {
        rowLengths[row] += 1;
        if (dirDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            dirDown = true;
        } else if (row == nRails - 1) {
            dirDown = false;
        }
    }

    var rowStarts = try allocator.alloc(usize, nRails);
    defer allocator.free(rowStarts);
    var sum: usize = 0;
    for (0..nRails) |i| {
        rowStarts[i] = sum;
        sum += rowLengths[i];
    }

    const result = try allocator.alloc(u8, len);
    row = 0;
    dirDown = true;
    var railCounters = try allocator.alloc(usize, nRails);
    defer allocator.free(railCounters);
    for (0..nRails) |i| railCounters[i] = 0;

    for (0..len) |i| {
        const r = row;
        result[i] = msg[rowStarts[r] + railCounters[r]];
        railCounters[r] += 1;

        if (dirDown) {
            row += 1;
        } else {
            row -= 1;
        }
        if (row == 0) {
            dirDown = true;
        } else if (row == nRails - 1) {
            dirDown = false;
        }
    }

    return result;
}
