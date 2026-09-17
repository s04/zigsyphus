const std = @import("std");
const mem = std.mem;

fn findRoot(parent: *[8]u3, vertex: u3) u3 {
    var current = vertex;
    while (parent[@as(usize, @intCast(current))] != current) {
        current = parent[@as(usize, @intCast(current))];
    }
    return current;
}

pub fn canChain(allocator: mem.Allocator, stones: []const [2]u3) mem.Allocator.Error!bool {
    _ = allocator;

    if (stones.len == 0) return true;

    var degrees: [8]u32 = .{ 0, 0, 0, 0, 0, 0, 0, 0 };
    var parent: [8]u3 = .{ 0, 1, 2, 3, 4, 5, 6, 7 };

    for (stones) |stone| {
        const a = stone[0];
        const b = stone[1];

        degrees[@as(usize, @intCast(a))] += 1;
        degrees[@as(usize, @intCast(b))] += 1;

        const a_root = findRoot(&parent, a);
        const b_root = findRoot(&parent, b);
        if (a_root != b_root) {
            parent[@as(usize, @intCast(a_root))] = b_root;
        }
    }

    for (degrees) |degree| {
        if (degree % 2 != 0) return false;
    }

    var start: ?u3 = null;
    for (stones) |stone| {
        if (degrees[@as(usize, @intCast(stone[0]))] > 0) {
            start = stone[0];
            break;
        }
    }

    const start_vertex = start orelse return true;
    const root = findRoot(&parent, start_vertex);

    for (degrees, 0..) |degree, i| {
        if (degree > 0) {
            const vertex: u3 = @intCast(i);
            if (findRoot(&parent, vertex) != root) return false;
        }
    }

    return true;
}
