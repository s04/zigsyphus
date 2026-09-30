pub const BucketId = enum {
    one,
    two,
};

pub const Result = struct {
    moves: u64,
    goal_bucket: BucketId,
    other_bucket: u64,
};

pub fn measure(bucket_one: u64, bucket_two: u64, goal: u64, start_bucket: BucketId) ?Result {
    // Check if goal is larger than both buckets
    if (goal > bucket_one and goal > bucket_two) {
        return null;
    }
    
    // Check if goal is not achievable (not a multiple of GCD)
    const gcd_val = gcd(bucket_one, bucket_two);
    if (goal % gcd_val != 0) {
        return null;
    }
    
    // BFS to find the minimum number of moves
    var visited = std.AutoHashMap([2]u64, void).init(std.heap.page_allocator);
    defer visited.deinit();
    
    var queue = std.ArrayList(State).init(std.heap.page_allocator);
    defer queue.deinit();
    
    // Initial state: fill the starting bucket
    var initial_state: State = undefined;
    if (start_bucket == .one) {
        initial_state = State{
            .bucket1 = bucket_one,
            .bucket2 = 0,
            .moves = 1,
            .last_action = .fill,
            .filled_bucket = .one,
        };
    } else {
        initial_state = State{
            .bucket1 = 0,
            .bucket2 = bucket_two,
            .moves = 1,
            .last_action = .fill,
            .filled_bucket = .two,
        };
    }
    
    try queue.append(initial_state);
    try visited.put(initial_state.getState(), {});
    
    while (queue.items.len > 0) {
        const current = queue.orderedRemoveAt(0);
        
        // Check if we've reached the goal
        if (current.bucket1 == goal) {
            return Result{
                .moves = current.moves,
                .goal_bucket = .one,
                .other_bucket = current.bucket2,
            };
        }
        if (current.bucket2 == goal) {
            return Result{
                .moves = current.moves,
                .goal_bucket = .two,
                .other_bucket = current.bucket1,
            };
        }
        
        // Generate all possible next states
        const next_states = generateNextStates(current, bucket_one, bucket_two, start_bucket);
        
        for (next_states) |next_state| {
            const state_key = next_state.getState();
            if (!visited.contains(state_key)) {
                try visited.put(state_key, {});
                try queue.append(next_state);
            }
        }
    }
    
    return null;
}

const State = struct {
    bucket1: u64,
    bucket2: u64,
    moves: u64,
    last_action: Action,
    filled_bucket: BucketId,
    
    fn getState(self: State) -> [2]u64 {
        return [2]u64{ self.bucket1, self.bucket2 };
    }
};

const Action = enum {
    fill,
    empty,
    pour,
};

fn gcd(a: u64, b: u64) -> u64 {
    var x = a;
    var y = b;
    while (y != 0) {
        const temp = y;
        y = x % y;
        x = temp;
    }
    return x;
}

fn generateNextStates(current: State, bucket_one: u64, bucket_two: u64, start_bucket: BucketId) []State {
    var states: [6]State = undefined;
    var count: usize = 0;
    
    // Fill bucket 1
    if (current.bucket1 < bucket_one) {
        states[count] = State{
            .bucket1 = bucket_one,
            .bucket2 = current.bucket2,
            .moves = current.moves + 1,
            .last_action = .fill,
            .filled_bucket = .one,
        };
        count += 1;
    }
    
    // Fill bucket 2
    if (current.bucket2 < bucket_two) {
        states[count] = State{
            .bucket1 = current.bucket1,
            .bucket2 = bucket_two,
            .moves = current.moves + 1,
            .last_action = .fill,
            .filled_bucket = .two,
        };
        count += 1;
    }
    
    // Empty bucket 1
    if (current.bucket1 > 0) {
        states[count] = State{
            .bucket1 = 0,
            .bucket2 = current.bucket2,
            .moves = current.moves + 1,
            .last_action = .empty,
            .filled_bucket = current.filled_bucket,
        };
        count += 1;
    }
    
    // Empty bucket 2
    if (current.bucket2 > 0) {
        states[count] = State{
            .bucket1 = current.bucket1,
            .bucket2 = 0,
            .moves = current.moves + 1,
            .last_action = .empty,
            .filled_bucket = current.filled_bucket,
        };
        count += 1;
    }
    
    // Pour from bucket 1 to bucket 2
    if (current.bucket1 > 0 and current.bucket2 < bucket_two) {
        const pour_amount = @min(current.bucket1, bucket_two - current.bucket2);
        states[count] = State{
            .bucket1 = current.bucket1 - pour_amount,
            .bucket2 = current.bucket2 + pour_amount,
            .moves = current.moves + 1,
            .last_action = .pour,
            .filled_bucket = current.filled_bucket,
        };
        count += 1;
    }
    
    // Pour from bucket 2 to bucket 1
    if (current.bucket2 > 0 and current.bucket1 < bucket_one) {
        const pour_amount = @min(current.bucket2, bucket_one - current.bucket1);
        states[count] = State{
            .bucket1 = current.bucket1 + pour_amount,
            .bucket2 = current.bucket2 - pour_amount,
            .moves = current.moves + 1,
            .last_action = .pour,
            .filled_bucket = current.filled_bucket,
        };
        count += 1;
    }
    
    return states[0..count];
}
