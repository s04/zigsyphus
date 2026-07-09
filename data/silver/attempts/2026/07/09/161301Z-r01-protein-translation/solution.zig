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
    if (c.len != 3) return TranslationError.InvalidCodon;

    const a = c[0];
    const b = c[1];
    const d = c[2];

    if (a == 'A' and b == 'U' and d == 'G') return .methionine;
    if (a == 'U' and b == 'U' and (d == 'U' or d == 'C')) return .phenylalanine;
    if (a == 'U' and b == 'U' and (d == 'A' or d == 'G')) return .leucine;
    if (a == 'U' and b == 'C' and (d == 'U' or d == 'C' or d == 'A' or d == 'G')) return .serine;
    if (a == 'U' and b == 'A' and (d == 'U' or d == 'C')) return .tyrosine;
    if (a == 'U' and b == 'G' and (d == 'U' or d == 'C')) return .cysteine;
    if (a == 'U' and b == 'G' and d == 'G') return .tryptophan;

    return TranslationError.InvalidCodon;
}

pub fn proteins(allocator: mem.Allocator, strand: []const u8) (mem.Allocator.Error || TranslationError)![]Protein {
    var list = std.mem.ArrayList(Protein).init(allocator);
    defer list.deinit();

    var i: usize = 0;
    var stopEncountered = false;

    while (i + 2 < strand.len) {
        const codon = strand[i .. i + 3];

        if (std.mem.eql(u8, codon, "UAA") or
            std.mem.eql(u8, codon, "UAG") or
            std.mem.eql(u8, codon, "UGA"))
        {
            stopEncountered = true;
            break;
        }

        const protein = try codonToProtein(codon);
        try list.append(protein);
        i += 3;
    }

    if (i < strand.len and !stopEncountered) {
        return TranslationError.InvalidCodon;
    }

    return try list.toOwnedSlice();
}
