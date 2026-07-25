const std = @import("std");
const EnumSet = std.enums.EnumSet;

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
    const mask: u8 = 1 << @intFromEnum(allergen);
    return (score & mask) != 0;
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    const allergens: [8]Allergen = .{
        .eggs,
        .peanuts,
        .shellfish,
        .strawberries,
        .tomatoes,
        .chocolate,
        .pollen,
        .cats,
    };

    var set = EnumSet(Allergen).initEmpty();
    const masked_score: u8 = @intCast(score & 0xFF);

    for (allergens) |a| {
        if (isAllergicTo(masked_score, a)) {
            set = set.add(a);
        }
    }
    return set;
}
