const std = @import("std");

pub fn modifier(score: i8) i8 {
    const s = score - 10;
    const div = @divFloor(s, 2);
    return div;
}

pub fn ability() i8 {
    // Seed the PRNG with the current timestamp
    const seed = std.time.timestamp(); // u64
    var prng = std.rand.DefaultPrng.init(seed);

    // Roll four six‑sided dice
    var rolls: [4]u8 = undefined;
    for (0..4) |i| {
        const die = @intCast(u8, prng.random().uintLessThan(u32, 6) + 1);
        rolls[i] = die;
    }

    // Sort the rolls in ascending order
    std.mem.sort(u8, rolls[0..], std.math.orderLess);

    // Sum the highest three dice (indices 1, 2, 3 after sorting)
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
