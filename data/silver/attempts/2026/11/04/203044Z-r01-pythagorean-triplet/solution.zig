```zig
const std = @import("std");
const mem = std.mem;

pub const Triplet = struct {
    a: usize,
    b: usize,
    c: usize,

    pub fn init(a: usize, b: usize, c: usize) Triplet {
        return Triplet{ .a = a, .b = b, .c = c };
    }
};

pub fn tripletsWithSum(allocator: mem.Allocator, n: usize) mem.Allocator.Error![]Triplet {
    var count: usize = 0;
    var a: usize = 1;
    while (a * 3 < n) : (a += 1) {
        var b: usize = a + 1;
        while (b * 2 < n - a) : (b += 1) {
            const c = n - a
