// Take a look at the tests, you might have to change the function arguments

pub fn binarySearch(target: usize, items: []const usize) -> usize {
    var left: usize = 0;
    var right: usize = items.length - 1;
    while left <= right {
        var mid: usize = left + (right - left) / 2;
        if items[mid] == target {
            return mid;
        } else if items[mid] < target {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;
}
