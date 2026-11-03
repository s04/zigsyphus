const std = @import("std");
const mem = std.mem;

/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    // First pass: count valid characters (letters and digits)
    var valid_count: usize = 0;
    for (s) |c| {
        if (std.ascii.isAlphabetic(c) or std.ascii.isDigit(c)) {
            valid_count += 1;
        }
    }

    // Calculate output size: valid chars + spaces (every 5 chars except possibly last)
    var space_count: usize = 0;
    if (valid_count > 0) {
        space_count = (valid_count - 1) / 5;
    }
    const output_len = valid_count + space_count;

    var output = try allocator.alloc(u8, output_len);
    var out_idx: usize = 0;
    var char_count: usize = 0;

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            // Apply Atbash: a<->z, b<->y, etc.
            const lower = std.ascii.toLower(c);
            const encoded = 'z' - (lower - 'a');
            output[out_idx] = encoded;
            out_idx += 1;
            char_count += 1;

            // Add space after every 5 characters (but not at the end)
            if (char_count % 5 == 0 and char_count != valid_count) {
                output[out_idx] = ' ';
                out_idx += 1;
            }
        } else if (std.ascii.isDigit(c)) {
            output[out_idx] = c;
            out_idx += 1;
            char_count += 1;

            if (char_count % 5 == 0 and char_count != valid_count) {
                output[out_idx] = ' ';
                out_idx += 1;
            }
        }
        // Skip punctuation and spaces
    }

    return output;
}

/// Decodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    // Count valid characters (letters and digits, ignoring spaces)
    var valid_count: usize = 0;
    for (s) |c| {
        if (std.ascii.isAlphabetic(c) or std.ascii.isDigit(c)) {
            valid_count += 1;
        }
    }

    var output = try allocator.alloc(u8, valid_count);
    var out_idx: usize = 0;

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const lower = std.ascii.toLower(c);
            const decoded = 'z' - (lower - 'a');
            output[out_idx] = decoded;
            out_idx += 1;
        } else if (std.ascii.isDigit(c)) {
            output[out_idx] = c;
            out_idx += 1;
        }
        // Skip spaces and punctuation
    }

    return output;
}
