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

const all_allergens = [_]Allergen{
    .eggs,
    .peanuts,
    .shellfish,
    .strawberries,
    .tomatoes,
    .chocolate,
    .pollen,
    .cats,
};

fn allergenValue(allergen: Allergen) u8 {
    return switch (allergen) {
        .eggs => 1,
        .peanuts => 2,
        .shellfish => 4,
        .strawberries => 8,
        .tomatoes => 16,
        .chocolate => 32,
        .pollen => 64,
        .cats => 128,
    };
}

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    return score & allergenValue(allergen) != 0;
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var set = EnumSet(Allergen).initEmpty();
    const valid_score = @as(u8, @intCast(score));
    for (all_allergens) |allergen| {
        if (valid_score & allergenValue(allergen) != 0) {
            set.set(allergen);
        }
    }
    return set;
}
