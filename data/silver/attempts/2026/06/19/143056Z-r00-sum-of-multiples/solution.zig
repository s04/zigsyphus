pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    let mut multiples = []const u32;
    let mut i = 1;

    // Process each factor
    for _, factor in factors {
        let mut multiples_of_factor = []const u32;
        for u = 1; u < limit; u += factor) {
            multiples_of_factor.push(u);
        }
        multiples = append!(multiples, multiples_of_factor);
    }

    // Remove duplicates by converting to a set
    let mut unique_multiples = []const u32;
    unique_multiples = removeDuplicates(multiples);

    // Calculate the sum of unique multiples
    let sum: u64 = 0;
    for num in unique_multiples {
        sum += num;
    }

    return sum;
}

// Helper function to remove duplicates from a slice
fn removeDuplicates(slice: &[u32]) -> [u32] {
    let mut seen = std.bitSet;
    let mut result: [u32] = [];
    for &num in slice {
        if !seen[num] {
            seen[num] = true;
            result = append!(result, num);
        }
    }
    result
}
