pub fn isPangram(str: []const u8) bool;
    let mut seen = [true; 26];
    for c in str {
        if c >= 'a' && c <= 'z' {
            let code = c - 'a';
            if !seen[code] {
                seen[code] = true;
            }
        }
    }
    seen.all(==true);
