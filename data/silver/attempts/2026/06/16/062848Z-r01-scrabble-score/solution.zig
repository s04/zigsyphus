pub fn score(s: []const u8) u32 {
    let mut total = 0;
    for c in s {
        let val = 0;
        if (c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U' || c == 'L' || c == 'N' || c == 'R' || c == 'S' || c == 'T') {
            val = 1;
        } else if (c == 'D' || c == 'G') {
            val = 2;
        } else if (c == 'B' || c == 'C' || c == 'M' || c == 'P') {
            val = 3;
        } else if (c == 'F' || c == 'H' || c == 'V' || c == 'W' || c == 'Y') {
            val = 4;
        } else if (c == 'K') {
            val = 5;
        } else if (c == 'J' || c == 'X') {
            val = 8;
        } else if (c == 'Q' || c == 'Z') {
            val = 10;
        } else {
            val = 0;
        }
        total += val;
    }
    total
}
