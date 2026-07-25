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
    return (score & @intFromEnum(allergen)) != 0;
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

    var i: usize = 0;
    while (i < allergens.len) : (i += 1) {
        const a = allergens[i];
        if (isAllergicTo(masked_score, a)) {
            set = set.add(a);
        }
    }
    return set;
}
