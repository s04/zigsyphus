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

fn isLeapYear(year: u12) bool {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    return year % 400 == 0;
}

fn daysInMonth(year: u12, month: u8) u8 {
    return switch (month) {
        1, 3, 5, 7, 8, 10, 12 => 31,
        4, 6, 9, 11 => 30,
        2 => if (isLeapYear(year)) 29 else 28,
        else => unreachable,
    };
}

fn dayOfWeek(year: u12, month: u8, day: u8) u8 {
    var y: i32 = @intCast(year);
    var m: i32 = @intCast(month);
    if (m < 3) {
        m += 12;
        y -= 1;
    }
    const K = y % 100;
    const J = y / 100;
    const h = @intCast(day) + (13 * (m + 1)) / 5 + K + K / 4 + J / 4 - 2 * J;
    var h_mod = @rem(h, 7);
    if (h_mod < 0) h_mod += 7;
    // h_mod: 0=Saturday, 1=Sunday, 2=Monday, 3=Tuesday, 4=Wednesday, 5=Thursday, 6=Friday
    // Map to 0=Monday, 1=Tuesday, ..., 6=Sunday
    const result = (h_mod + 5) % 7;
    return @intCast(result);
}

pub fn meetup(year: u12, month: Month, week: Week, day_of_week: DayOfWeek) [10]u8 {
    const month_num = @intFromEnum(month) + 1;
    const target_weekday = @intFromEnum(day_of_week);
    const dim = daysInMonth(year, month_num);

    var matches: [7]u8 = undefined;
    var count: u8 = 0;
    for (1..dim + 1) |day| {
        const wd = dayOfWeek(year, month_num, @intCast(day));
        if (wd == target_weekday) {
            matches[count] = @intCast(day);
            count += 1;
        }
    }

    var result_day: u8 = undefined;
    switch (week) {
        .first => result_day = matches[0],
        .second => result_day = matches[1],
        .third => result_day = matches[2],
        .fourth => result_day = matches[3],
        .last => result_day = matches[count - 1],
        .teenth => {
            for (13..20) |day| {
                if (day <= dim) {
                    const wd = dayOfWeek(year, month_num, @intCast(day));
                    if (wd == target_weekday) {
                        result_day = @intCast(day);
                        break;
                    }
                }
            } else {
                unreachable;
            }
        },
    }

    const year_u16 = @intCast(year);
    var result: [10]u8 = undefined;
    result[0] = '0' + @intCast(year_u16 / 1000);
    result[1] = '0' + @intCast((year_u16 / 100) % 10);
    result[2] = '0' + @intCast((year_u16 / 10) % 10);
    result[3] = '0' + @intCast(year_u16 % 10);
    result[4] = '-';
    result[5] = '0' + @intCast(month_num / 10);
    result[6] = '0' + @intCast(month_num % 10);
    result[7] = '-';
    result[8] = '0' + @intCast(result_day / 10);
    result[9] = '0' + @intCast(result_day % 10);
    return result;
}
