pub fn combinations(buffer: []u9, sum: usize, size: usize, exclude: u9) []const u9 {
    var count: usize = 0;
    
    fn backtrack(start: usize, remaining_sum: usize, remaining_size: usize, current_mask: u9) void {
        if (remaining_size == 0) {
            if (remaining_sum == 0) {
                if (count < buffer.len) {
                    buffer[count] = current_mask;
                    count += 1;
                }
            }
            return;
        }
        
        if (start > 9) return;
        if (remaining_sum < remaining_size) return; // minimum sum is 1+2+...+remaining_size
        if (remaining_sum > 9 * remaining_size) return; // maximum sum
        
        for (digit in start..10) {
            const bit = u9(1) << (digit - 1);
            if ((exclude & bit) != 0) continue;
            if (digit > remaining_sum) break;
            backtrack(digit + 1, remaining_sum - digit, remaining_size - 1, current_mask | bit);
        }
    }
    
    backtrack(1, sum, size, 0);
    return buffer[0..count];
}
