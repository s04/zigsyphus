const std = @import("std");
const EnumSet = std.EnumSet;

pub const Allergen = enum {
    eggs,
    peanuts,
    shellfish,
    strawberries,
    tomatoes,
    chocolate,
    pollen,
    cats,
};

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    const mask: u8 = @as(u8, 1) << @intFromEnum(allergen);
    return (score & mask) != 0;
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var set = EnumSet(Allergen).initEmpty();
    const masked_score: u8 = @intCast(score & 0xFF);
    var i: u8 = 0;
    while (i < 8) : (i += 1) {
        const allergen = @as(Allergen, @enumFromInt(i));
        if (isAllergicTo(masked_score, allergen)) {
            set.set(allergen);
        }
    }
    return set;
}
