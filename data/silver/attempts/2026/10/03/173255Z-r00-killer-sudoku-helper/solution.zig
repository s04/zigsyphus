const std = @import("std");

pub fn combinations(buffer: []u9, sum: usize, size: usize, exclude: u9) []const u9 {
    // Use the buffer length as maximum possible number of combinations.
    const max_combs = buffer.len;
    var masks: [max_combs]u9 = undefined;
    var count: usize = 0;

    // Recursive backtracking to generate all combinations of `size` distinct digits (1..9)
    // that sum to `sum` and do not contain any digit present in `exclude`.
    const gen = struct {
        fn backtrack(start: u4, remaining: usize, cur_sum: usize, mask: u9) void {
            if (remaining == 0) {
                if (cur_sum == sum and (mask & exclude) == 0) {
                    if (count < max_combs) {
                        masks[count] = mask;
                        count += 1;
                    } else {
                        // The provided buffer is too small for all valid combinations.
                        // In the context of the tests this should never happen.
                        @panic("buffer too small");
                    }
                }
                return;
            }

            // Try each digit from `start` to 9.
            for (start..10) |d| {
                const digit = @as(u4, @intCast(d));
                // Skip digits that are excluded.
                if ((exclude & (@as(u9, 1) << @intCast(digit - 1))) != 0) {
                    continue;
                }
                // Prune if adding this digit would exceed the target sum.
                if (cur_sum + digit > sum) {
                    continue;
                }
                const new_mask = mask | (@as(u9, 1) << @intCast(digit - 1));
                backtrack(@intCast(digit + 1), remaining - 1, cur_sum + digit, new_mask);
            }
        }
    }.backtrack;

    // Start the search.
    gen(@intCast(1), size, 0, 0);

    // Sort the generated masks in ascending order.
    std.sort.asc(u9, masks[0..count]);

    // Copy the sorted masks into the provided buffer.
    std.mem.copyForwards(u9, buffer, masks[0..count]);

    return buffer[0..count];
}
