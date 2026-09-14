const std = @import("std");
const mem = std.mem;

/// Encodes `msg` using the rail fence cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const max_rails = 8; // u3 ranges from 0 to 7, so 8 is sufficient
    if (rails < 1) {
        return try allocator.dupe(u8, &[]);
    }
    if (rails == 1 or msg.len <= rails) {
        return try allocator.dupe(u8, msg);
    }

    var rail_chars: [max_rails][]u8 = undefined;
    var rail_lengths: [max_rails]usize = {0} ** max_rails;

    for (0..max_rails) |i| {
        rail_chars[i] = try allocator.alloc(u8, msg.len);
    }

    var rail_idx: usize = 0;
    var direction: i32 = 1;

    for (msg) |c| {
        rail_chars[rail_idx][rail_lengths[rail_idx]] = c;
        rail_lengths[rail_idx] += 1;

        if (rail_idx == 0) {
            direction = 1;
        } else if (rail_idx == rails - 1) {
            direction = -1;
        }

        if (direction > 0) {
            rail_idx += 1;
        } else {
            rail_idx -= 1;
        }
    }

    var result = try allocator.alloc(u8, msg.len);
    var result_idx: usize = 0;
    for (0..rails) |i| {
        for (0..rail_lengths[i]) |j| {
            result[result_idx] = rail_chars[i][j];
            result_idx += 1;
        }
    }

    for (0..max_rails) |i| {
        allocator.free(rail_chars[i]);
    }

    return result;
}

/// Decodes `msg` using the rail fence cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    const max_rails = 8; // u3 ranges from 0 to 7, so 8 is sufficient
    if (rails < 1) {
        return try allocator.dupe(u8, &[]);
    }
    if (rails == 1 or msg.len <= rails) {
        return try allocator.dupe(u8, msg);
    }

    var rail_lengths: [max_rails]usize = {0} ** max_rails;
    var rail_idx: usize = 0;
    var direction: i32 = 1;

    for (0..msg.len) |_| {
        rail_lengths[rail_idx] += 1;

        if (rail_idx == 0) {
            direction = 1;
        } else if (rail_idx == rails - 1) {
            direction = -1;
        }

        if (direction > 0) {
            rail_idx += 1;
        } else {
            rail_idx -= 1;
        }
    }

    var rail_chars: [max_rails][]u8 = undefined;
    for (0..max_rails) |i| {
        rail_chars[i] = try allocator.alloc(u8, rail_lengths[i]);
    }

    var msg_idx: usize = 0;
    for (0..rails) |i| {
        for (0..rail_lengths[i]) |j| {
            rail_chars[i][j] = msg[msg_idx];
            msg_idx += 1;
        }
    }

    var result = try allocator.alloc(u8, msg.len);
    rail_idx = 0;
    var rail_positions: [max_rails]usize = {0} ** max_rails;
    direction = 1;

    for (0..msg.len) |i| {
        result[i] = rail_chars[rail_idx][rail_positions[rail_idx]];
        rail_positions[rail_idx] += 1;

        if (rail_idx == 0) {
            direction = 1;
        } else if (rail_idx == rails - 1) {
            direction = -1;
        }

        if (direction > 0) {
            rail_idx += 1;
        } else {
            rail_idx -= 1;
        }
    }

    for (0..max_rails) |i| {
        allocator.free(rail_chars[i]);
    }

    return result;
}
