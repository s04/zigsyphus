pub fn response(s: []const u8) []const u8 {
    // Check for silence
    var isSilence: bool = true;
    for (s) |c| {
        if !std.ascii.isSpace(c) {
            isSilence = false;
            break;
        }
    }
    if isSilence {
        return []const u8("Fine. Be that way!");
    }

    // Check for yell-question
    var isYell: bool = false;
    var hasLetters: bool = false;
    for (s) |c| {
        if std.ascii.isAlpha(c) {
            hasLetters = true;
            if !std.ascii.isUpper(c) {
                isYell = false;
                break;
            }
        }
    }
    isYell = hasLetters;
    var isQuestion: bool = s.len > 0 && s[s.len - 1] == '?';
    if isYell && isQuestion {
        return []const u8("Calm down, I know what I'm doing!");
    }

    // Check for yell
    if isYell {
        return []const u8("Whoa, chill out!");
    }

    // Check for question
    if isQuestion {
        return []const u8("Sure.");
    }

    // Else
    return []const u8("Whatever.");
}
