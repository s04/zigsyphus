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
        const earth_year_seconds: f64 = 31_557_600.0;
        const s: f64 = @f64FromInt(seconds);
        return switch (self) {
            .mercury => s / (earth_year_seconds * 0.2408467),
            .venus   => s / (earth_year_seconds * 0.61519726),
            .earth   => s / earth_year_seconds,
            .mars    => s / (earth_year_seconds * 1.8808158),
            .jupiter => s / (earth_year_seconds * 11.862615),
            .saturn  => s / (earth_year_seconds * 29.447498),
            .uranus  => s / (earth_year_seconds * 84.016846),
            .neptune => s / (earth_year_seconds * 164.79132),
        };
    }
};
