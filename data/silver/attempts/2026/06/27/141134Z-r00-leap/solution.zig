pub fn isLeapYear(year: u32) bool {
    if year % 400 == 0 {
        return true;
    } else if year % 100 == 0 {
        return year % 4 == 0;
    } else if year % 4 == 0 {
        return year % 100 != 0 || year % 400 == 1;
    } else {
        return false;
    }
}
