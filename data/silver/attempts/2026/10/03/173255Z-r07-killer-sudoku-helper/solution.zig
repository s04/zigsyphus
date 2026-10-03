const std = @import("std");

pub fn combinations(buffer: []u9, sum: usize, size: usize, exclude: u9) []const u9 {
    var state = struct {
        buffer: []u9,
        count: usize,
        sum: usize,
        size: usize,
        exclude: u9,
    }{
        .buffer = buffer,
        .count = 0,
        .sum = sum,
        .size = size,
        .exclude = exclude,
    };

    const Frame = struct {
        start: u9,
        current_sum: usize,
        current_bitmask: u9,
        length: usize,
    };

    var stack: [100]Frame = undefined;
    var stack_top: usize = 0;

    stack[stack_top] = Frame{
        .start = 1,
        .current_sum = 0,
        .current_bitmask = 0,
        .length = 0,
    };
    stack_top += 1;

    while (stack_top > 0) {
        stack_top -= 1;
        const frame = stack[stack_top];

        if (frame.length == state.size) {
            if (frame.current_sum == state.sum) {
                if (state.count < state.buffer.len) {
                    state.buffer[state.count] = frame.current_bitmask;
                    state.count += 1;
                } else {
                    break;
                }
            }
        } else if (frame.length < state.size) {
            var digit: u4 = 9;
            while (digit >= frame.start) {
                if ((state.exclude & (@as(u9, 1) << (digit - 1))) == 0) {
                    const new_sum = frame.current_sum + digit;
                    if (new_sum <= state.sum) {
                        const new_bitmask = frame.current_bitmask | (@as(u9, 1) << (digit - 1));
                        const new_length = frame.length + 1;
                        if (stack_top < stack.len) {
                            stack[stack_top] = Frame{
                                .start = digit + 1,
                                .current_sum = new_sum,
                                .current_bitmask = new_bitmask,
                                .length = new_length,
                            };
                            stack_top += 1;
                        }
                    }
                }
                if (digit == 1) break;
                digit -= 1;
            }
        }
    }

    const Comparator = struct {
        pub fn lessThan(context: void, a: u9, b: u9) bool {
            _ = context;
            return a < b;
        }
    };

    std.sort.sort(u9, state.buffer[0..state.count], {}, Comparator.lessThan);

    return state.buffer[0..state.count];
}
