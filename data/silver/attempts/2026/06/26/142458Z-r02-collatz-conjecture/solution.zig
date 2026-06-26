const std = @import("std");

const ComputationError = error{usize}! {
    IllegalArgument = 0,
};

pub fn steps(number: usize) ComputationError!usize {
    if (number == 0) {
        return ComputationError.IllegalArgument;
    }
    
    var n: usize = number;
    var count: usize = 0;
    
    while (n != 1) {
        if (n % 2 == 0) {
            n = n / 2;
        } else {
            n = n * 3 + 1;
        }
        count += 1;
    }
    
    return count;
}
