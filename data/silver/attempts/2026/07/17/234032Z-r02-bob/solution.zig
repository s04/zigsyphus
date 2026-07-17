const std = @import("std");

pub fn response(s: []const u8) []const u8 {
    // Check for silence (only whitespace)
    var has_content: bool = false;
    for (s) |c| {
        if (!std.ascii.isSpace(c)) {
            has_content = true;
            break;
        }
    }

    if (!has_content) {
        return "Fine. Be that way!";
    }

    // Trim trailing whitespace to find the actual last character
    var trimmed_end = s;
    while (trimmed_end.len > 0 and std.ascii.isSpace(trimmed_end[trimmed_end.len - 1])) {
        trimmed_end = trimmed_end[0.. trimmed_end.len - 1];
    }

    const is_question = trimmed_end.len > 0 and trimmed_end[trimmed_end.len - 1] == '?';

    // Check for yelling (all letters are uppercase and there is at least one letter)
    var has_letters: bool = false;
    var all_uppercase: bool = true;
    for (s) |c| {
        if (std.ascii.isLetter(c)) {
            has_letters = true;
            if (std.ascii.isLower(c)) {
                all_uppercase = false;
            }
        }
    }

    const is_yelling = has_letters and all_uppercase;

    if (is_yelling and is_question) {
        return "Calm down, I know what I'm doing!";
    }
    if (is_yelling) {
        return "Whoa, chill out!";
    }
    if (is_question) {
        return "Sure.";
    }

    return "Whatever.";
}
