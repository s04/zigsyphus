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
    const month_num: u32 = @intFromEnum(month) + 1;
    const target_dow: u32 = @intFromEnum(day_of_week);

    const days_in_month = daysInMonth(year, month_num);

    const first_dow = dayOfWeek(year, month_num, 1);
    const offset: u32 = (target_dow + 7 - first_dow) % 7;

    var day: u32 = 1 + offset;

    switch (week) {
        .first => {},
        .second => day += 7,
        .third => day += 14,
        .fourth => day += 21,
        .teenth => {
            while (day < 13) {
                day += 7;
            }
        },
        .last => {
            const last_dow = dayOfWeek(year, month_num, days_in_month);
            var last_day: u32 = days_in_month;
            const last_offset: i32 = @as(i32, @intCast(last_dow)) - @as(i32, @intCast(target_dow));
            if (last_offset > 0) {
                last_day -= @as(u32, @intCast(last_offset));
            } else if (last_offset < 0) {
                last_day -= @as(u32, @intCast(last_offset + 7));
            }
            day = last_day;
        },
    }

    var buf: [10]u8 = undefined;
    const year_str = std.fmt.bufPrint(buf[0..4], "{d}", .{year}) catch unreachable;
    const month_str = std.fmt.bufPrint(buf[5..7], "{d:0>2}", .{month_num}) catch unreachable;
    const day_str = std.fmt.bufPrint(buf[8..10], "{d:0>2}", .{day}) catch unreachable;

    @memcpy(buf[0..4], year_str);
    buf[4] = '-';
    @memcpy(buf[5..7], month_str);
    buf[7] = '-';
    @memcpy(buf[8..10], day_str);

    return buf;
}

fn isLeapYear(year: u32) bool {
    return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
}

fn daysInMonth(year: u32, month: u32) u32 {
    return switch (month) {
        1 => 31,
        2 => if (isLeapYear(year)) 29 else 28,
        3 => 31,
        4 => 30,
        5 => 31,
        6 => 30,
        7 => 31,
        8 => 31,
        9 => 30,
        10 => 31,
        11 => 30,
        12 => 31,
        else => unreachable,
    };
}

fn dayOfWeek(year: u32, month: u32, day: u32) u32 {
    var y: i32 = @intCast(year);
    var m: i32 = @intCast(month);
    if (m < 3) {
        m += 12;
        y -= 1;
    }
    const K: i32 = y % 100;
    const J: i32 = y / 100;
    const h: i32 = (day + @divFloor(13 * (m + 1), 5) + K + @divFloor(K, 4) + @divFloor(J, 4) - 2 * J) % 7;
    const d: u32 = @intCast(((h + 5) % 7 + 7) % 7);
    return d;
}
