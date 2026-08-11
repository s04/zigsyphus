const std = @import("std");

pub fn modifier(score: i8) i8 {
    const s = score - 10;
    const div = s / 2;
    if (s < 0 and @rem(s, 2) != 0) {
        return div - 1;
    }
    return div;
}

pub fn ability() i8 {
    // Global PRNG seeded once
    const seed = @intCast(u64, std.time.nanoTimestamp());
    var prng = std.rand.DefaultPrng.init(seed);
    var rolls: [4]u8 = undefined;
    for (0..4) |i| {
        rolls[i] = @intCast(u8, prng.random().uintLessThan(u32, 6) + 1);
    }
    std.mem.sort(u8, rolls[0..], std.math.orderLess);
    const sum = rolls[1] + rolls[2] + rolls[3];
    return @intCast(i8, sum);
}

pub const Character = struct {
    strength: i8,
    dexterity: i8,
    constitution: i8,
    intelligence: i8,
    wisdom: i8,
    charisma: i8,
    hitpoints: i8,

    pub fn init() Character {
        const str = ability();
        const dex = ability();
        const con = ability();
        const int = ability();
        const wis = ability();
        const cha = ability();
        const hp = 10 + modifier(con);
        return Character{
            .strength = str,
            .dexterity = dex,
            .constitution = con,
            .intelligence = int,
            .wisdom = wis,
            .charisma = cha,
            .hitpoints = hp,
        };
    }
};
