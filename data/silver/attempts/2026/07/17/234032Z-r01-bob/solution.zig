const std = @import("std");

pub fn response(s: []const u8) []const u8 {
    // 1. Check for silence (only whitespace)
    var has_content: bool = false;
    var last_char: u8 = 0;
    for (s) |c| {
        if (!std.ascii.isSpace(c)) {
            has_content = true;
        }
        last_char = c;
    }

    if (!has_content) {
        return "Fine. Be that way!";
    }

    // 2. Check for question (ends with '?')
    // Note: The problem implies trailing whitespace doesn't prevent a question
    // but the tests show "Okay if like my spacebar quite a bit?   " is a question.
    // However, "Ending with? means a question." is a statement.
    // Looking at tests: "ending with whitespace" for a question returns "Sure."
    // "ending with whitespace" for a statement returns "Whatever."
    // This means we must trim trailing whitespace to find the actual last character.
    
    var trimmed_end = s;
    while (trimmed_end.len > 0 and std.ascii.isSpace(trimmed_end[trimmed_end.len - 1])) {
        trimmed_end = trimmed_end[0.. trimmed_end.len - 1];
    }
    
    const is_question = trimmed_end.len > 0 and trimmed_end[trimmed_end.len - 1] == '?';

    // 3. Check for yelling (all letters are uppercase and there is at least one letter)
    var is_yelling: bool = false;
    var has_letters: bool = false;
    for (s) |c| {
        if (std.ascii.isLetter(c)) {
            has_letters = true;
            if (std.ascii.isLower(c)) {
                is_yelling = false;
                // We don't break here because we need to check if there are letters at all
                // but if we find a lowercase, it's definitely not yelling.
                // Actually, we can break if we know it's not yelling.
                goto_not_yelling: {
                    is_yelling = false;
                    break :for;
                }
            }
        }
    }
    
    // Re-evaluating yelling logic:
    // Yelling means: all letters are uppercase AND there is at least one letter.
    var yell_check_yelling = has_letters;
    for (s) |c| {
        if (std.ascii.isLetter(c)) {
            if (std.ascii.isLower(c)) {
                yell_check_yelling = false;
                break;
            }
        }
    }

    if (yell_check_yelling and is_question) {
        return "Calm down, I know what I'm doing!";
    }
    if (yell_check_yelling) {
        return "Whoa, chill out!";
    }
    if (is_question) {
        return "Sure.";
    }

    return "Whatever.";
}
