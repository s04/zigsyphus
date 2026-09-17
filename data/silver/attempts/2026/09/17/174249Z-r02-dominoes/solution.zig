const std = @import("std");
const mem = std.mem;

pub fn canChain(allocator: mem.Allocator, stones: []const [2]u3) mem.Allocator.Error!bool {
    if (stones.len == 0) return true;

    // Find maximum vertex value to size arrays
    var max: u3 = 0;
    for (stones) |stone| {
        if (stone[0] > max) max = stone[0];
        if (stone[1] > max) max = stone[1];
    }
    const size = @as(usize, max) + 1;

    // Compute degrees
    var deg = try allocator.alloc(u32, size);
    defer allocator.free(deg);
    for (deg) |*d| d.* = 0;
    for (stones) |stone| {
        deg[stone[0]] += 1;
        deg[stone[1]] += 1;
    }

    // All vertices must have even degree for an Eulerian circuit
    for (deg) |d| {
        if (d % 2 != 0) return false;
    }

    // BFS to check connectivity of vertices with non-zero degree
    var visited = try allocator.alloc(bool, size);
    defer allocator.free(visited);
    for (visited) |*v| v.* = false;

    var start: ?usize = null;
    for (0..size) |i| {
        if (deg[i] > 0) {
            start = i;
            break;
        }
    }
    const s = start orelse return true; // no edges (should not happen here)

    var stack = std.ArrayList(u32).init(allocator);
    defer stack.deinit();
    try stack.append(@intCast(u32, s));

    while (stack.items.len > 0) {
        const v = stack.items[stack.items.len - 1];
        stack.items.len -= 1; // pop
        if (visited[v]) continue;
        visited[v] = true;

        for (stones) |stone| {
            const a = stone[0];
            const b = stone[1];
            if (a == v) {
                if (!visited[b]) try stack.append(b);
            } else if (b == v) {
                if (!visited[a]) try stack.append(a);
            }
        }
    }

    // Ensure every vertex with degree > 0 was visited
    for (0..size) |i| {
        if (deg[i] > 0 and !visited[i]) return false;
    }

    return true;
}
