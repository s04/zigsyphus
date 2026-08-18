const std = @import("std");

pub const Relation = enum {
    equal,
    sublist,
    superlist,
    unequal,
};

fn isSublist(small: []const i32, big: []const i32) bool {
    if (small.len == 0) {
        return true;
    }
    var i: usize = 0;
    while (i <= big.len - small.len) : (i += 1) {
        if (std.mem.eql(i32, small, big[i..i+small.len])) {
            return true;
        }
    }
    return false;
}

pub fn compare(list_one: []const i32, list_two: []const i32) Relation {
    if (list_one.len == list_two.len) {
        if (std.mem.eql(i32, list_one, list_two)) {
            return .equal;
        }
        return .unequal;
    }
    if (list_one.len < list_two.len) {
        if (isSublist(list_one, list_two)) {
            return .sublist;
        }
        return .unequal;
    }
    // list_one.len > list_two.len
    if (isSublist(list_two, list_one)) {
        return .superlist;
    }
    return .unequal;
}
