pub const BufferError = error{BufferOverflow};

pub fn CircularBuffer(comptime T: type, comptime capacity: usize) type {
    return struct {
        const Self = @This();

        buf: [capacity]T,
        head: usize,
        tail: usize,
        full: bool,

        pub fn init() Self {
            return Self{
                .buf = undefined,
                .head = 0,
                .tail = 0,
                .full = false,
            };
        }

        pub fn clear(self: *Self) void {
            self.head = 0;
            self.tail = 0;
            self.full = false;
        }

        pub fn read(self: *Self) ?T {
            if (!self.full and self.head == self.tail) {
                return null;
            }
            const value = self.buf[self.tail];
            const was_full = self.full;
            self.tail = (self.tail + 1) % self.buf.len;
            if (was_full) {
                self.full = false;
            }
            return value;
        }

        pub fn write(self: *Self, item: T) BufferError!void {
            if (self.full) {
                return error.BufferOverflow;
            }
            self.buf[self.head] = item;
            self.head = (self.head + 1) % self.buf.len;
            if (self.head == self.tail) {
                self.full = true;
            }
        }

        pub fn overwrite(self: *Self, item: T) void {
            self.buf[self.head] = item;
            self.head = (self.head + 1) % self.buf.len;
            if (self.full) {
                self.tail = (self.tail + 1) % self.buf.len;
            } else if (self.head == self.tail) {
                self.full = true;
            }
        }
    };
}
