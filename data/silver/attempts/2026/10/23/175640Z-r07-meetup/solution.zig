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

pub fn meetup(year: u12, month: Month, week: Week, day_of_week: DayOfWeek) [10]u8 {
    const month_num: u5 = @intFromEnum(month) + 1;
    const dow_num: u5 = @intFromEnum(day_of_week);

    const days_in_month = [_]u8{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    var dim: u8 = days_in_month[@intCast(month_num - 1)];
    if (month_num == 2) {
        const is_leap = (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
        if (is_leap) dim = 29;
    }

    var day: u8 = 1;
    var found: ?u8 = null;

    while (day <= dim) : (day += 1) {
        const dow = dayOfWeek(year, month_num, day);
        if (dow == dow_num) {
            switch (week) {
                .teenth => {
                    if (day >= 13 and day <= 19) {
                        found = day;
                        break;
                    }
                },
                .first => {
                    if (day <= 7) {
                        found = day;
                        break;
                    }
                },
                .second => {
                    if (day >= 8 and day <= 14) {
                        found = day;
                        break;
                    }
                },
                .third => {
                    if (day >= 15 and day <= 21) {
                        found = day;
                        break;
                    }
                },
                .fourth => {
                    if (day >= 22 and day <= 28) {
                        found = day;
                        break;
                    }
                },
                .last => {
                    found = day;
                },
            }
        }
    }

    const result_day = found.?;
    var buf: [10]u8 = undefined;
    _ = std.fmt.bufPrint(&buf, "{d:04}-{d:02}-{d:02}", .{ year, month_num, result_day }) catch unreachable;
    return buf;
}

fn dayOfWeek(year: u12, month: u5, day: u8) u5 {
    const y: u16 = if (month < 3) @as(u16, @intCast(year)) - 1 else @as(u16, @intCast(year));
    const m: u16 = if (month < 3) @as(u16, @intCast(month)) + 12 else @as(u16, @intCast(month));
    const k: u16 = y % 100;
    const j: u16 = y / 100;
    const h: u16 = (@as(u16, @intCast(day)) + (13 * (m + 1)) / 5 + k + k / 4 + j / 4 + 5 * j) % 7;
    // h: 0=Saturday, 1=Sunday, 2=Monday, ..., 6=Friday
    // Convert to: 0=Monday, 1=Tuesday, ..., 6=Sunday
    return @intCast((h + 5) % 7);
}
