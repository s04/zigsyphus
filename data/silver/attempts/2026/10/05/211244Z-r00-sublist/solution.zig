const std = @import("std");

pub const Relation = enum {
    equal,
    sublist,
    superlist,
    unequal,
};

fn isSublist(a: []const i32, b: []const i32) bool {
    if (a.len == 0) return true;
    if (b.len < a.len) return false;
    for (b[0..b.len - a.len + 1], 0..) |_, i| {
        if (std.mem.eql(i32, a, b[i..i + a.len])) {
            return true;
        }
    }
    return false;
}

pub fn compare(list_one: []const i32, list_two: []const i32) Relation {
    if (std.mem.eql(i32, list_one, list_two)) {
        return .equal;
    }
    if (isSublist(list_one, list_two)) {
        return .sublist;
    }
    if (isSublist(list_two, list_one)) {
        return .superlist;
    }
    return .unequal;
}
