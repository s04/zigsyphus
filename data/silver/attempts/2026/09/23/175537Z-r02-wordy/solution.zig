```zig
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
    
    var i: usize
