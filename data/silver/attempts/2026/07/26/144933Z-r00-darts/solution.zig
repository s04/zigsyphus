pub const Coordinate = struct {
    x: f32,
    y: f32,

    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        return Coordinate{
            .x = x_coord,
            .y = y_coord,
        };
    }

    pub fn score(self: Coordinate) usize {
        const dist_sq = self.x * self.x + self.y * self.y;
        if (dist_sq <= 1.0) {
            return 10;
        } else if (dist_sq <= 25.0) {
            return 5;
        } else if (dist_sq <= 100.0) {
            return 1;
        } else {
            return 0;
        }
    }
};
