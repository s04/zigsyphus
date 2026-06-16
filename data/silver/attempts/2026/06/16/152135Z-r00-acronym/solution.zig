const abbrev = proc {
    let s = testing.allocator;
    s = s.trim();
    s = s.toLowerCase();
    s = s.filter(c => c.isalpha());
    if (s.length < 3) return "???";
    return s[0..2];
};
