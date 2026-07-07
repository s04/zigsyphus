const std = @import("std");
const mem = std.mem;

pub fn toRna(allocator: mem.Allocator, dna: []const u8) mem.Allocator.Error![]const u8 {
    const rna = try allocator.alloc(u8, dna.len);
    for (dna, 0..) |nucleotide, i| {
        rna[i] = switch (nucleotide) {
            'G' => 'C',
            'C' => 'G',
            'T' => 'A',
            'A' => 'U',
            else => '?',
        };
    }
    return rna;
}
