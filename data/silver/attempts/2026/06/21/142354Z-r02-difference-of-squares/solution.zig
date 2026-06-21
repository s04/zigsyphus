pub fn squareOfSum(number: usize) usize {
    var sum: usize = 0;
    for (0..number) |i| {
        sum += i + 1;
    }
    return sum * sum;
}

pub fn sumOfSquares(number: usize) usize {
    var sum: usize = 0;
    for (1..number + 1) |i| {
        sum += i * i;
    }
    return sum;
}

pub fn differenceOfSquares(number: usize) usize {
    const squareOfSum = squareOfSum(number);
    const sumOfSquares = sumOfSquares(number);
    return squareOfSum - sumOfSquares;
}
