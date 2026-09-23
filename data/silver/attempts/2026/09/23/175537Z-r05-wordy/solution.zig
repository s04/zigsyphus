const std = @import("std");

pub const ArgumentError = error{
    UnsupportedQuestion,
    SyntaxError,
    DivisionByZero,
};

pub fn answer(question: []const u8) ArgumentError!i32 {
    if (!std.mem.startsWith(u8, question, "What is ")) return ArgumentError.UnsupportedQuestion;
    if (question.len < 9) return ArgumentError.SyntaxError;
    if (question[question.len - 1] != '?') return ArgumentError.UnsupportedQuestion;

    const content = question[8 .. question.len - 1];
    var iter = std.mem.tokenizeAny(u8, content, " ");

    const first_token = iter.next() orelse return ArgumentError.SyntaxError;
    var result = std.fmt.parseInt(i32, first_token, 10) catch return ArgumentError.SyntaxError;

    while (iter.next()) |op| {
        // If the token is a number, it means we have two numbers in a row (invalid syntax)
        if (std.fmt.parseInt(i32, op, 10)) |_| {
            return ArgumentError.SyntaxError;
        } else |_| {
            if (std.mem.eql(u8, op, "plus")) {
                const num_str = iter.next() orelse return ArgumentError.SyntaxError;
                const num = std.fmt.parseInt(i32, num_str, 10) catch return ArgumentError.SyntaxError;
                result += num;
            } else if (std.mem.eql(u8, op, "minus")) {
                const num_str = iter.next() orelse return ArgumentError.SyntaxError;
                const num = std.fmt.parseInt(i32, num_str, 10) catch return ArgumentError.SyntaxError;
                result -= num;
            } else if (std.mem.eql(u8, op, "multiplied")) {
                const by = iter.next() orelse return ArgumentError.SyntaxError;
                if (!std.mem.eql(u8, by, "by")) return ArgumentError.UnsupportedQuestion;
                const num_str = iter.next() orelse return ArgumentError.SyntaxError;
                const num = std.fmt.parseInt(i32, num_str, 10) catch return ArgumentError.SyntaxError;
                result *= num;
            } else if (std.mem.eql(u8, op, "divided")) {
                const by = iter.next() orelse return ArgumentError.SyntaxError;
                if (!std.mem.eql(u8, by, "by")) return ArgumentError.UnsupportedQuestion;
                const num_str = iter.next() orelse return ArgumentError.SyntaxError;
                const num = std.fmt.parseInt(i32, num_str, 10) catch return ArgumentError.SyntaxError;
                if (num == 0) return ArgumentError.DivisionByZero;
                result = @divTrunc(result, num);
            } else {
                return ArgumentError.UnsupportedQuestion;
            }
        }
    }

    return result;
}
