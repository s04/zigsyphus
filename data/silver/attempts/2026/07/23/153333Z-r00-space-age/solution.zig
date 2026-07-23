const std = @import("std");

pub const Planet = enum {
    pub mercury,
    pub venus,
    pub earth,
    pub mars,
    pub jupiter,
    pub saturn,
    pub uranus,
    pub neptune,
};

pub fn age(self: Planet, seconds: usize) f64 {
    const SECONDS_PER_EARTH_YEAR = 31_557_600.0;
    switch (self) {
        case .mercury:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 0.2408467);
        case .venus:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 0.61519726);
        case .earth:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 1.0);
        case .mars:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 1.8808158);
        case .jupiter:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 11.862615);
        case .saturn:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 29.447498);
        case .uranus:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 84.016846);
        case .neptune:
            return f64(seconds) / (SECONDS_PER_EARTH_YEAR * 164.79132);
    }
}
