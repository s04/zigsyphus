pub const BufferError = error{BufferOverflow};

pub fn CircularBuffer(comptime T: type, comptime capacity: usize) type {
    return struct {
        const Self = @This();

        var buffer: [capacity]T,
        var read_index: usize,
        var write_index: usize,
        var count: usize;

        /// Initializes a CircularBuffer
        pub fn init() Self {
            return Self{
                .buffer = undefined,
                .read_index = 0,
                .write_index = 0,
                .count = 0,
            };
        }

        /// Discards all items in the buffer.
        pub fn clear(self: *Self) void {
            self.read_index = 0;
            self.write_index = 0;
            self.count = 0;
        }

        /// Extracts the oldest item from the buffer.
        pub fn read(self: *Self) ?T {
            if (self.count == 0) {
                return null;
            }
            const item = self.buffer[self.read_index];
            self.read_index = (self.read_index + 1) % capacity;
            self.count -= 1;
            return item;
        }

        /// Write `item` into the buffer.
        pub fn write(self: *Self, item: T) BufferError!void {
            if (self.count == capacity) {
                return error.BufferOverflow;
            }
            self.buffer[self.write_index] = item;
            self.write_index = (self.write_index + 1) % capacity;
            self.count += 1;
        }

        /// Write `item` into the buffer, replacing the oldest item if necessary.
        pub fn overwrite(self: *Self, item: T) void {
            if (self.count == capacity) {
                self.read_index = (self.read_index + 1) % capacity;
                self.count -= 1;
            }
            self.buffer[self.write_index] = item;
            self.write_index = (self.write_index + 1) % capacity;
            self.count += 1;
        }
    };
}
