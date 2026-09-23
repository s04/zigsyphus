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
    
    if (content.len == 0) return ArgumentError.SyntaxError;
    
    var tokens = std.ArrayList([]const u8).init(std.heap.page_allocator);
    defer tokens.deinit();
    
    var iter = std.mem.tokenizeAny(u8, content, " ");
    while (iter.next()) |word| {
        if (std.mem.eql(u8, word, "multiplied")) {
            const next = iter.next() orelse return ArgumentError.SyntaxError;
            if (!std.mem.eql(u8, next, "by")) return ArgumentError.UnsupportedQuestion;
            try tokens.append("multiplied by");
        } else {
            try tokens.append(word);
        }
    }
    
    if (tokens.items.len == 0) return ArgumentError.SyntaxError;
    
    var result = std.fmt.parseInt(i32, tokens.items[0], 10) catch {
        return ArgumentError.SyntaxError;
    };
    
    if (tokens.items.len == 1) return result;
    
    var i: usize = 1;
    while (i < tokens.items.len) {
        const op = tokens.items[i];
        
        if (i + 1 >= tokens.items.len) return ArgumentError.SyntaxError;
        
        const next_token = tokens.items[i + 1];
        const num = std.fmt.parseInt(i32, next_token, 10) catch {
            return ArgumentError.SyntaxError;
        };
        
        if (std.mem.eql(u8, op, "plus")) {
            result += num;
        } else if (std.mem.eql(u8, op, "minus")) {
            result -= num;
        } else if (std.mem.eql(u8, op, "multiplied by")) {
            result *= num;
        } else if (std.mem.eql(u8, op, "divided by")) {
            if (num == 0) return ArgumentError.DivisionByZero;
            result /= num;
        } else {
            return ArgumentError.UnsupportedQuestion;
        }
        
        i += 2;
    }
    
    return result;
}
