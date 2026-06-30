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
        const r_squared = self.x * self.x + self.y * self.y;
        const r = @sqrt(r_squared);

        if (r > 10.0) {
            return 0;
        } else if (r > 5.0) {
            return 1;
        } else if (r > 1.0) {
            return 5;
        } else {
            return 10;
        }
    }
};
