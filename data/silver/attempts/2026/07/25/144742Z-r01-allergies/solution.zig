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
    // The enum value itself is the bit mask (1, 2, 4, ...).
    // Bitwise AND with the score tells us if that bit is set.
    return (score & @intCast(allergen)) != 0;
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    // Build a list of all known allergens.
    const allergens: [8]Allergen = [_]Allergen{
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
    // Only the low 8 bits of the score are relevant.
    const masked_score: u8 = @intCast(score & 0xFF);

    var i: usize = 0;
    while (i < allergens.len) : (i += 1) {
        const a = allergens[i];
        if (isAllergicTo(masked_score, a)) {
            // EnumSet.add returns a new set with the allergen added.
            set = set.add(a);
        }
    }
    return set;
}
