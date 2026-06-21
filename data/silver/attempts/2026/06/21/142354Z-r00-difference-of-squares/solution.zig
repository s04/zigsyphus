pub fn differenceOfSquares(number: usize) usize {
    const sumOfSquares = sumOfSquares(number);
    const squareOfSum = squareOfSum(number);
    return squareOfSum - sumOfSquares;
}
