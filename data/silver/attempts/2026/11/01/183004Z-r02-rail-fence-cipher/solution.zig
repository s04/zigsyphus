const std = @import("std");
const mem = std.mem;

pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const nRails: usize = @intCast(rails);
    const len = msg.len;
    if (len == 0 or nRails <= 1) {
        const result = try allocator.alloc(u8, len);
        mem.copy(result, msg);
        return result;
    }

    // count how many characters fall on each rail
    var rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (0..nRails) |_| rowLengths[_] = 0;

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

    // compute starting index of each rail in the output buffer
    var rowStarts = try allocator.alloc(usize, nRails);
    defer allocator.free(rowStarts);
    var sum: usize = 0;
    for (0..nRails) |i| {
        rowStarts[i] = sum;
        sum += rowLengths[i];
    }

    // fill the result by walking the zig‑zag path
    var counters = try allocator.alloc(usize, nRails);
    defer allocator.free(counters);
    for (0..nRails) |_| counters[_] = 0;

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

pub fn decode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const nRails: usize = @intCast(rails);
    const len = msg.len;
    if (len == 0 or nRails <= 1) {
        const result = try allocator.alloc(u8, len);
        mem.copy(result, msg);
        return result;
    }

    // first pass: determine how many chars belong to each rail
    var rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (0..nRails) |_| rowLengths[_] = 0;

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

    // compute cumulative start positions for each rail inside `msg`
    var rowStarts = try allocator.alloc(usize, nRails);
    defer allocator.free(rowStarts);
    var sum: usize = 0;
    for (0..nRails) |i| {
        rowStarts[i] = sum;
        sum += rowLengths[i];
    }

    // second pass: re‑walk the zig‑zag and pull chars from the correct rail segments
    const result = try allocator.alloc(u8, len);
    row = 0;
    dirDown = true;
    var railCounters = try allocator.alloc(usize, nRails);
    defer allocator.free(railCounters);
    for (0..nRails) |_| railCounters[_] = 0;

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
