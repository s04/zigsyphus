const std = @import("std");

pub const ArgumentError = error{
    UnsupportedQuestion,
    SyntaxError,
    DivisionByZero,
};

pub fn answer(question: []const u8) ArgumentError!i32 {
    // Must start with "What is"
    const prefix = "What is";
    if (!std.mem.startsWith(u8, question, prefix)) {
        return ArgumentError.UnsupportedQuestion;
    }

    const after_prefix = question[prefix.len..];
    if (after_prefix.len == 0) {
        return ArgumentError.SyntaxError;
    }
    if (after_prefix[0] != ' ') {
        return ArgumentError.SyntaxError;
    }

    // Remove the leading space
    let mut content = after_prefix[1..];

    // Must end with '?'
    if (content.len == 0 || content[content.len - 1] != '?') {
        return ArgumentError.UnsupportedQuestion;
    }
    content = content[0..content.len - 1]; // trim off '?'

    // Tokenize the content by spaces
    var tokens = std.mem.tokenizeAny(u8, content, " ");

    const first = tokens.next() orelse return ArgumentError.SyntaxError;
    var acc = std.fmt.parseInt(i32, first, 10) catch return ArgumentError.SyntaxError;

    while (tokens.next()) |op| {
        // If we can parse the token as an integer, it means two numbers in a row -> syntax error
        if (std.fmt.parseInt(i32, op, 10)) |_| {
            return ArgumentError.SyntaxError;
        }

        // Otherwise, it should be an operator
        const num_str = tokens.next() orelse return ArgumentError.SyntaxError;
        const num = std.fmt.parseInt(i32, num_str, 10) catch return ArgumentError.SyntaxError;

        if (std.mem.eql(u8, op, "plus")) {
            acc += num;
        } else if (std.mem.eql(u8, op, "minus")) {
            acc -= num;
        } else if (std.mem.eql(u8, op, "multiplied")) {
            const by = tokens.next() orelse return ArgumentError.SyntaxError;
            if (!std.mem.eql(u8, by, "by")) return ArgumentError.UnsupportedQuestion;
            const multiplier = std.fmt.parseInt(i32, tokens.next() orelse return ArgumentError.SyntaxError, 10) catch return ArgumentError.SyntaxError;
            acc *= multiplier;
        } else if (std.mem.eql(u8, op, "divided")) {
            const by = tokens.next() orelse return ArgumentError.SyntaxError;
            if (!std.mem.eql(u8, by, "by")) return ArgumentError.UnsupportedQuestion;
            const divisor = std.fmt.parseInt(i32, tokens.next() orelse return ArgumentError.SyntaxError, 10) catch return ArgumentError.SyntaxError;
            if (divisor == 0) return ArgumentError.DivisionByZero;
            acc = @divTrunc(acc, divisor);
        } else {
            return ArgumentError.UnsupportedQuestion;
        }
    }

    return acc;
}
