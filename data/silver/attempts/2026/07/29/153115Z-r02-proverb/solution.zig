fn free(slices: [][]u8) void {
    for (slices) |s| {
        testing.allocator.free(s);
    }
    testing.allocator.free(slices); // No problem when `slices` has zero length.
}
