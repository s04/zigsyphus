pub const Direction = enum {
    north,
    east,
    south,
    west,
};

pub const Robot = struct {
    x: i32,
    y: i32,
    direction: Direction,

    pub fn init(x: i32, y: i32, direction: Direction) Robot {
        return Robot{ .x = x, .y = y, .direction = direction };
    }

    pub fn move(self: *Robot, instructions: []const u8) void {
        for (instructions) |c| {
            const dir = self.direction;
            if (c == 'R') {
                const idx = switch (dir) {
                    .north => 0,
                    .east => 1,
                    .south => 2,
                    .west => 3,
                };
                const newIdx = (idx + 1) % 4;
                self.direction = switch (newIdx) {
                    0 => .north,
                    1 => .east,
                    2 => .south,
                    3 => .west,
                };
            } else if (c == 'L') {
                const idx = switch (dir) {
                    .north => 0,
                    .east => 1,
                    .south => 2,
                    .west => 3,
                };
                const newIdx = (idx + 3) % 4;
                self.direction = switch (newIdx) {
                    0 => .north,
                    1 => .east,
                    2 => .south,
                    3 => .west,
                };
            } else if (c == 'A') {
                if (dir == .north) {
                    self.y += 1;
                } else if (dir == .south) {
                    self.y -= 1;
                } else if (dir == .east) {
                    self.x += 1;
                } else if (dir == .west) {
                    self.x -= 1;
                }
            }
        }
    }
};
