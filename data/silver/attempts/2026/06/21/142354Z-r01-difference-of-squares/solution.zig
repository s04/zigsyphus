pub fn squareOfSum(number: usize) usize {
    var sum = 0usize;
    for i in 0..number {
        sum += i + 1;
    }
    return sum * sum;
}

pub fn sumOfSquares(number: usize) usize {
    var sum = 0usize;
    for i in 1..number + 1 {
        sum += i * i;
    }
    return sum;
}

pub fn differenceOfSquares(number: usize) usize {
    const squareOfSum = squareOfSum(number);
    const sumOfSquares = sumOfSquares(number);
    return squareOfSum - sumOfSquares;
}
