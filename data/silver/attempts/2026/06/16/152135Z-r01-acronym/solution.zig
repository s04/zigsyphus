const abbrev = proc {
    let s = testing.allocator();
    s = s.trim();
    s = s.toLowerCase();
    s = s.replace(/[^a-z]/g, "");
    if (s.length < 3) return "???";
    return s[0..2];
};
