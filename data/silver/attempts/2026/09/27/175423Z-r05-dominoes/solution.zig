const std = @import("std");
const mem = std.mem;

pub fn canChain(allocator: mem.Allocator, stones: []const [2]u3) mem.Allocator.Error!bool {
    _ = allocator;
    
    if (stones.len == 0) return true;
    
    var degree = [_]u32{0} ** 8;
    var adj = [_][8]bool{[_]bool{false} ** 8} ** 8;
    
    for (stones) |stone| {
        const a = stone[0];
        const b = stone[1];
        degree[a] += 1;
        if (a == b) {
            degree[a] += 1;
        } else {
            degree[b] += 1;
            adj[a][b] = true;
            adj[b][a] = true;
        }
    }
    
    var start: u3 = 0;
    var found_start = false;
    var i: usize = 0;
    while (i < 8) : (i += 1) {
        if (degree[i] > 0) {
            start = @intCast(i);
            found_start = true;
            break;
        }
    }
    
    if (!found_start) return true;
    
    var visited = [_]bool{false} ** 8;
    var stack = [_]u3{0} ** 8;
    var sp: usize = 0;
    
    stack[sp] = start;
    sp += 1;
    visited[start] = true;
    
    while (sp > 0) {
        sp -= 1;
        const v = stack[sp];
        var u_i: usize = 0;
        while (u_i < 8) : (u_i += 1) {
            const u = @intCast(u_i);
            if (adj[v][u] and !visited[u]) {
                visited[u] = true;
                stack[sp] = u;
                sp += 1;
            }
        }
    }
    
    i = 0;
    while (i < 8) : (i += 1) {
        if (degree[i] > 0 and !visited[i]) {
            return false;
        }
    }
    
    i = 0;
    while (i < 8) : (i += 1) {
        if (degree[i] % 2 != 0) {
            return false;
        }
    }
    
    return true;
}
