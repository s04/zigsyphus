pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) ![]const u8 {
    const days: []const []const u8 = [
        "a Partridge in a Pear Tree",
        "two Turtle Doves",
        "three French Hens",
        "four Calling Birds",
        "five Gold Rings",
        "six Geese-a-Laying",
        "seven Swans-a-Swimming",
        "eight Maids-a-Milking",
        "nine Ladies Dancing",
        "ten Lords-a-Leaping",
        "eleven Pipers Piping",
        "twelve Drummers Drumming"
    ];
    
    var result: []const u8 = undefined;
    for (start_verse..end_verse) |i| {
        var verse: []const u8 = "On the " + @intCast(u32, i + 1) + " day of Christmas my true love gave to me: ";
        for (days[0..i+1]) |day| {
            verse = verse + day + ", ";
        }
        verse = verse[0..@count(verse)-2] + " and a Partridge in a Pear Tree.";
        result = result + verse + "\n";
    }
    return result;
}
