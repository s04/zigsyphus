const std = @import("std");

pub const Plant = enum {
    clover,
    grass,
    radishes,
    violets,
};

pub fn plants(diagram: []const u8, student: []const u8) [4]Plant {
    const students = [_][]const u8{
        "Alice", "Bob", "Charlie", "David", "Eve", "Fred",
        "Ginny", "Harriet", "Ileana", "Joseph", "Kincaid", "Larry",
    };

    var idx: usize = 0;
    var found = false;
    while (idx < students.len) : (idx += 1) {
        if (std.mem.eql(u8, students[idx], student)) {
            found = true;
            break;
        }
    }
    if (!found) return .{ .clover, .clover, .clover, .clover };

    const start = idx * 2;

    const charToPlant = struct {
        fn map(c: u8) Plant {
            return switch (c) {
                'G' => Plant.grass,
                'C' => Plant.clover,
                'R' => Plant.radishes,
                'V' => Plant.violets,
                else => Plant.grass,
            };
        }
    }.map;

    if (diagram.len < 2) return .{ .clover, .clover, .clover, .clover };

    const row0 = diagram[0];
    const row1 = diagram[1];

    const p0 = charToPlant(row0[start]);
    const p1 = charToPlant(row0[start + 1]);
    const p2 = charToPlant(row1[start]);
    const p3 = charToPlant(row1[start + 1]);

    return .{ p0, p1, p2, p3 };
}
