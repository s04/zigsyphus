const std = @import("std");
const mem = std.mem;

pub fn canChain(allocator: mem.Allocator, stones: []const [2]u3) mem.Allocator.Error!bool {
    if (stones.len == 0) {
        return true;
    }

    const max_vertex = 7; // u3 max value
    var degree: [max_vertex + 1]u32 = .{0}.*;
    var adj: [max_vertex + 1]std.ArrayList(u3) = undefined;
    for (0..max_vertex + 1) |v| {
        adj[v] = std.ArrayList(u3).init(allocator);
    }
    defer {
        for (0..max_vertex + 1) |v| {
            adj[v].deinit();
        }
    }

    for (stones) |stone| {
        const a = stone[0];
        const b = stone[1];
        degree[a] += 1;
        degree[b] += 1;
        try adj[a].append(b);
        if (a != b) {
            try adj[b].append(a);
        }
    }

    // Check even degree for all vertices with degree > 0
    var odd_count: u32 = 0;
    for (degree) |d, v| {
        if (d == 0) continue;
        if (d % 2 != 0) {
            odd_count += 1;
        }
    }
    if (odd_count != 0) {
        return false;
    }

    // Find start vertex (any with degree > 0)
    var start: ?usize = null;
    for (degree) |d, v| {
        if (d > 0) {
            start = v;
            break;
        }
    }
    if (start == null) {
        // No edges (should have been caught earlier)
        return true;
    }
    const start_v = start.?;

    // DFS to check connectivity
    var visited = [_]bool{false} ** (max_vertex + 1);
    var stack = std.ArrayList(usize).init(allocator);
    defer stack.deinit();
    try stack.append(start_v);
    visited[start_v] = true;

    while (stack.items.len > 0) {
        const v = stack.pop();
        for (adj[v].items) |n| {
            if (!visited[n]) {
                visited[n] = true;
                try stack.append(n);
            }
        }
    }

    // Verify all vertices with degree > 0 are visited
    for (degree) |d, v| {
        if (d > 0 and !visited[v]) {
            return false;
        }
    }

    return true;
}
