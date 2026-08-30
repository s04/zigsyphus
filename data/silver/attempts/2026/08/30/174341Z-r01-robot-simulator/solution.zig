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
            if (c == 'R') {
                if (self.direction == .north) {
                    self.direction = .east;
                } else if (self.direction == .east) {
                    self.direction = .south;
                } else if (self.direction == .south) {
                    self.direction = .west;
                } else if (self.direction == .west) {
                    self.direction = .north;
                }
            } else if (c == 'L') {
                if (self.direction == .north) {
                    self.direction = .west;
                } else if (self.direction == .west) {
                    self.direction = .south;
                } else if (self.direction == .south) {
                    self.direction = .east;
                } else if (self.direction == .east) {
                    self.direction = .north;
                }
            } else if (c == 'A') {
                if (self.direction == .north) {
                    self.y += 1;
                } else if (self.direction == .south) {
                    self.y -= 1;
                } else if (self.direction == .east) {
                    self.x += 1;
                } else if (self.direction == .west) {
                    self.x -= 1;
                }
            }
        }
    }
};
