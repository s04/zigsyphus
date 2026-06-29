import std.algorithm;

pub fn binarySearch(target: usize, items: []const usize) -> usize {
    let left = 0;
    let right = items.length - 1;
    while left <= right {
        let mid = left + (right - left) / 2;
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
