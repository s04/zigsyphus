const std = @import("std");

pub const Month = enum {
    january,
    february,
    march,
    april,
    may,
    june,
    july,
    august,
    september,
    october,
    november,
    december,
};

pub const Week = enum {
    first,
    second,
    third,
    fourth,
    teenth,
    last,
};

pub const DayOfWeek = enum {
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
};

fn monthToNumber(month: Month) u8 {
    return @intFromEnum(month) + 1;
}

fn isLeapYear(year: u12) bool {
    const y = year;
    return (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0);
}

fn daysInMonth(year: u12, month: Month) u8 {
    switch (month) {
        .january, .march, .may, .july, .august, .october, .december => return 31,
        .april, .june, .september, .november => return 30,
        .february => return if (isLeapYear(year)) 29 else 28,
    }
}

/// Returns day of week where 0=Monday, 1=Tuesday, ..., 6=Sunday (matching DayOfWeek enum)
fn dayOfWeek(year: u12, month: u8, day: u8) u8 {
    // Sakamoto algorithm: returns 0=Sunday, 1=Monday, ..., 6=Saturday
    const t = [_]u8{0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    var y = year;
    if (month < 3) y -= 1;
    const sakamoto = (y + y/4 - y/100 + y/400 + t[month-1] + day) % 7;
    // Convert to 0=Monday, ..., 6=Sunday
    return (sakamoto + 6) % 7;
}

fn formatDate(year: u12, month: u8, day: u8) [10]u8 {
    var buf: [10]u8 = undefined;
    // Year (4 digits)
    buf[0] = @as(u8, @intCast(year / 1000 % 10)) + '0';
    buf[1] = @as(u8, @intCast(year / 100 % 10)) + '0';
    buf[2] = @as(u8, @intCast(year / 10 % 10)) + '0';
    buf[3] = @as(u8, @intCast(year % 10)) + '0';
    buf[4] = '-';
    // Month (2 digits)
    buf[5] = @as(u8, @intCast(month / 10)) + '0';
    buf[6] = @as(u8, @intCast(month % 10)) + '0';
    buf[7] = '-';
    // Day (2 digits)
    buf[8] = @as(u8, @intCast(day / 10)) + '0';
    buf[9] = @as(u8, @intCast(day % 10)) + '0';
    return buf;
}

pub fn meetup(year: u12, month: Month, week: Week, day_of_week: DayOfWeek) [10]u8 {
    const month_num = monthToNumber(month);
    const target_dow = @intFromEnum(day_of_week);
    const dim = daysInMonth(year, month_num);

    // Find first day of month's day of week
    const first_dow = dayOfWeek(year, month_num, 1);

    // Days until first target day of week (0-6)
    var days_until_first: u8 = 0;
    if (first_dow <= target_dow) {
        days_until_first = target_dow - first_dow;
    } else {
        days_until_first = 7 - (first_dow - target_dow);
    }

    const first_occurrence = 1 + days_until_first;

    switch (week) {
        .first => {
            return formatDate(year, month_num, first_occurrence);
        },
        .second => {
            return formatDate(year, month_num, first_occurrence + 7);
        },
        .third => {
            return formatDate(year, month_num, first_occurrence + 14);
        },
        .fourth => {
            return formatDate(year, month_num, first_occurrence + 21);
        },
        .teenth => {
            // Check days 13-19
            var day: u8 = 13;
            while (day <= 19) : (day += 1) {
                if (dayOfWeek(year, month_num, day) == target_dow) {
                    return formatDate(year, month_num, day);
                }
            }
            unreachable;
        },
        .last => {
            // Start from last day of month, go backwards
            var day: u8 = dim;
            while (day >= 1) : (day -= 1) {
                if (dayOfWeek(year, month_num, day) == target_dow) {
                    return formatDate(year, month_num, day);
                }
            }
            unreachable;
        },
    }
}
