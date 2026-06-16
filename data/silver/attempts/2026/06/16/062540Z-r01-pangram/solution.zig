pub fn isPangram(str: []const u8) bool {
    let mut seen = [true; 26];
    for (let i = 0; i < str.length; i++) {
        let c = str[i];
        if (c >= 'a' && c <= 'z') {
            let code = c - 'a';
            if (!seen[code]) {
                seen[code] = true;
            }
        }
    }
    return seen.all(==true);
}

pub const age = fn(self: Planet, seconds: usize) -> f64 {
    const earth_year_seconds = 31_557_600.0;
    let s: f64 = seconds / earth_year_seconds;
    return s * @f64FromInt(0.2408467);
}

pub fn isPangram(str: []const u8) bool {
    let s = str;
    return isPangram(s);
}
