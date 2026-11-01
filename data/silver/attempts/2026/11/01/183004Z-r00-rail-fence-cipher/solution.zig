```zig
const std = @import("std");
const mem = std.mem;

pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    if rails == 1 {
        const result = try allocator.alloc(u8, msg.len);
        @memcpy(result, msg, msg.len);
        return result;
    }

    const nRails = rails;
    const rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (rowLengths) |i| {
        rowLengths[i] = 0;
    }

    var row: usize = 0;
    var goingDown: bool = true;
    for (msg) |c| {
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

    var totalLen: usize = 0;
    for (rowLengths) |len| {
        totalLen += len;
    }

    const result = try allocator.alloc(u8, totalLen);
    const rowCounters = try allocator.alloc(usize, nRails);
    defer allocator.free(rowCounters);
    for (rowCounters) |i| {
        rowCounters[i] = 0;
    }

    row = 0;
    goingDown = true;
    var pos: usize = 0;
    for (msg) |c| {
        const len = rowLengths[row];
        const cnt = rowCounters[row];
        var offset: usize = 0;
        for (i in 0..row) {
            offset += rowLengths[i];
        }
        offset += cnt;
        result[offset] = c;
        rowCounters[row] = cnt + 1;

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
    if rails == 1 {
        const result = try allocator.alloc(u8, msg.len);
        @memcpy(result, msg, msg.len);
        return result;
    }

    const nRails = rails;
    const rowLengths = try allocator.alloc(usize, nRails);
    defer allocator.free(rowLengths);
    for (rowLengths) |i| {
        rowLengths[i] = 0;
    }

    var row: usize = 0;
    var goingDown: bool = true;
    for (msg) |c| {
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
    for (row in 0..nRails) |row| {
        rowStarts[row] = sum;
        sum += rowLengths[row];
    }

    const rowCounters = try allocator.alloc(usize, nRails);
    defer allocator.free(rowCounters);
    for (rowCounters) |i| {
        rowCounters[i] = 0;
    }

    const result = try allocator.alloc(u8, msg.len);
    row = 0;
    goingDown = true;
    var pos: usize = 0;

    for (i, 0..msg.len) |_| {
        const r = row;
        const cnt = rowCounters[r];
        const rowSlice = msg[rowStarts[r] : rowStarts[r] + rowLengths[r]];
        const ch = rowSlice[cnt];
        result[pos] = ch;
        pos += 1;
        rowCounters[r] = cnt + 1;

        if (goingDown) {
            row += 1;
        } else {
            row -= 1;
        }
