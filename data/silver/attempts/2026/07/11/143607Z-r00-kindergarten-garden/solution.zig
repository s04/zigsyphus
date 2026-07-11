pub const Plant = enum {
    clover,
    grass,
    radishes,
    violets,
};

pub fn plants(diagram: []const u8, student: []const u8) [4]Plant {
    // List of students in alphabetical order
    const students = [_][]const u8{
        "Alice", "Bob", "Charlie", "David", "Eve", "Fred",
        "Ginny", "Harriet", "Ileana", "Joseph", "Kincaid", "Larry",
    };

    // Find the index of the requested student
    var idx: usize = 0;
    var found = false;
    while (idx < students.len) : (idx += 1) {
        if (std.mem.eql(u8, students[idx], student)) {
            found = true;
            break;
        }
    }
    // If the student is not found, return an empty array (should not happen in tests)
    if (!found) return .{ .clover, .clover, .clover, .clover };

    // Each student has 4 cups: 2 per row
    const start = idx * 2;

    // Helper to map a character to Plant
    const charToPlant = struct {
        fn map(c: u8) Plant {
            return switch (c) {
                'G' => Plant.grass,
                'C' => Plant.clover,
                'R' => Plant.radishes,
                'V' => Plant.violets,
                else => Plant.grass, // default, should not occur
            };
        }
    }.map;

    // Ensure diagram has at least two rows
    if (diagram.len < 2) return .{ .clover, .clover, .clover, .clover };

    const row0 = diagram[0];
    const row1 = diagram[1];

    // Extract the four characters for this student
    const p0 = charToPlant(row0[start]);
    const p1 = charToPlant(row0[start + 1]);
    const p2 = charToPlant(row1[start]);
    const p3 = charToPlant(row1[start + 1]);

    return .{ p0, p1, p2, p3 };
}
