const std = @import("std");
const mem = std.mem;

pub const TranslationError = error{
    InvalidCodon,
};

pub const Protein = enum {
    methionine,
    phenylalanine,
    leucine,
    serine,
    tyrosine,
    cysteine,
    tryptophan,
};

fn codonToProtein(c: []const u8) !Protein {
    // Expect exactly three bytes
    if (c.len != 3) {
        return @error(TranslationError.InvalidCodon);
    }
    const a = c[0];
    const b = c[1];
    const d = c[2];

    // Methionine
    if (a == 'A' and b == 'U' and d == 'G') {
        return .methionine;
    }
    // Phenylalanine
    if (a == 'U' and b == 'U' and (d == 'U' or d == 'C')) {
        return .phenylalanine;
    }
    // Leucine
    if (a == 'U' and b == 'U' and (d == 'A' or d == 'G')) {
        return .leucine;
    }
    // Serine
    if (a == 'U' and b == 'C' and (d == 'U' or d == 'C' or d == 'A' or d == 'G')) {
        return .serine;
    }
    // Tyrosine
    if (a == 'U' and b == 'A' and (d == 'U' or d == 'C')) {
        return .tyrosine;
    }
    // Cysteine
    if (a == 'U' and b == 'G' and (d == 'U' or d == 'C')) {
        return .cysteine;
    }
    // Tryptophan
    if (a == 'U' and b == 'G' and d == 'G') {
        return .tryptophan;
    }

    // If none match, it's an invalid codon
    return @error(TranslationError.InvalidCodon);
}

pub fn proteins(allocator: mem.Allocator, strand: []const u8) (mem.Allocator.Error || TranslationError)![]Protein {
    const proteins = std.mem.ArrayList(Protein).init(allocator);
    var i: usize = 0;
    var stopEncountered: bool = false;

    while (i + 2 < strand.len) {
        const codon = strand[i: i + 3];

        // Check for STOP codon
        if (codon == "UAA" or codon == "UAG" or codon == "UGA") {
            stopEncountered = true;
            break;
        }

        // Translate codon
        const maybeProtein = codonToProtein(codon);
        if (maybeProtein == .error) {
            return TranslationError.InvalidCodon;
        }

        // Append the protein to the list
        try proteins.append(maybeProtein);
        i += 3;
    }

    // If there are leftover bytes and we didn't stop because of a STOP codon, it's invalid
    if (i < strand.len and not stopEncountered) {
        return TranslationError.InvalidCodon;
    }

    // Return the collected proteins
    return proteins;
}
