const std = @import("std");
const mem = std.mem;

fn getRailIndices(allocator: mem.Allocator, len: usize, rails: u3) ![]u32 {
    if (rails <= 1) {
        const indices = try allocator.alloc(u32, len);
        mem.set(u32, indices, 0);
        return indices;
    }
    
    const indices = try allocator.alloc(u32, len);
    var current_rail: u32 = 0;
    var direction: i32 = 1;
    
    for (0..len) |i| {
        indices[i] = current_rail;
        current_rail = @intCast(@as(i32, current_rail) + direction);
        if (current_rail == 0 or current_rail == rails - 1) {
            direction *= -1;
        }
    }
    
    return indices;
}

pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    if (rails <= 1) {
        return allocator.dupe(u8, msg);
    }
    
    const indices = try getRailIndices(allocator, msg.len, rails);
    defer allocator.free(indices);
    
    var counts = try allocator.alloc(usize, rails);
    defer allocator.free(counts);
    mem.set(usize, counts, 0);
    
    for (indices) |idx| {
        counts[idx] += 1;
    }
    
    var result = try allocator.alloc(u8, msg.len);
    
    var offsets = try allocator.alloc(usize, rails);
    defer allocator.free(offsets);
    offsets[0] = 0;
    for (1..rails) |i| {
        offsets[i] = offsets[i-1] + counts[i-1];
    }
    
    var positions = try allocator.alloc(usize, rails);
    defer allocator.free(positions);
    mem.copy(usize, positions, offsets);
    
    for (msg, 0..) |c, i| {
        const rail = indices[i];
        result[positions[rail]] = c;
        positions[rail] += 1;
    }
    
    return result;
}

pub fn decode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    if (rails <= 1) {
        return allocator.dupe(u8, msg);
    }
    
    const indices = try getRailIndices(allocator, msg.len, rails);
    defer allocator.free(indices);
    
    var counts = try allocator.alloc(usize, rails);
    defer allocator.free(counts);
    mem.set(usize, counts, 0);
    
    for (indices) |idx| {
        counts[idx] += 1;
    }
    
    var rail_buffers = try allocator.alloc([]const u8, rails);
    defer allocator.free(rail_buffers);
    
    var pos: usize = 0;
    for (0..rails) |i| {
        rail_buffers[i] = msg[pos..pos+counts[i]];
        pos += counts[i];
    }
    
    var result = try allocator.alloc(u8, msg.len);
    var rail_positions = try allocator.alloc(usize, rails);
    defer allocator.free(rail_positions);
    mem.set(usize, rail_positions, 0);
    
    for (0..msg.len) |i| {
        const rail = indices[i];
        result[i] = rail_buffers[rail][rail_positions[rail]];
        rail_positions[rail] += 1;
    }
    
    return result;
}
