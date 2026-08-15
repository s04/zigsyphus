// Please implement the `ComputationError.IllegalArgument` error.

const ComputationError = error set {
    IllegalArgument: void,
};

pub fn steps(number: usize) anyerror!usize {
    if (number == 0) return error.IllegalArgument;
    var n: usize = number;
    var steps: usize = 0;
    while (n != 1) {
        if (n % 2 == 0) {
            n = n / 2;
        } else {
            n = n * 3 + 1;
        }
        steps += 1;
    }
    return steps;
}
