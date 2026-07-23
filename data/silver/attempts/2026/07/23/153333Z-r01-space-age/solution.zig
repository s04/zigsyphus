pub const Planet = enum {
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn age(self: Planet, seconds: usize) f64 {
        const SECONDS_PER_EARTH_YEAR: f64 = 31_557_600.0;
        const sec: f64 = @floatFromInt(seconds);
        return switch (self) {
            .mercury => sec / (SECONDS_PER_EARTH_YEAR * 0.2408467),
            .venus => sec / (SECONDS_PER_EARTH_YEAR * 0.61519726),
            .earth => sec / (SECONDS_PER_EARTH_YEAR * 1.0),
            .mars => sec / (SECONDS_PER_EARTH_YEAR * 1.8808158),
            .jupiter => sec / (SECONDS_PER_EARTH_YEAR * 11.862615),
            .saturn => sec / (SECONDS_PER_EARTH_YEAR * 29.447498),
            .uranus => sec / (SECONDS_PER_EARTH_YEAR * 84.016846),
            .neptune => sec / (SECONDS_PER_EARTH_YEAR * 164.79132),
        };
    }
};
