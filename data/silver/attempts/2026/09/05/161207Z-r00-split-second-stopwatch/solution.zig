const std = @import("std");
const mem = std.mem;
const ArrayList = std.ArrayList;

pub const StopwatchError = error{
    AlreadyRunning,
    NotRunning,
    NotStopped,
};

pub const StopwatchState = enum {
    ready,
    running,
    stopped,
};

fn formatTime(seconds: u64) [8]u8 {
    var buf: [8]u8 = undefined;
    const hours = seconds / 3600;
    const minutes = (seconds % 3600) / 60;
    const secs = seconds % 60;
    buf[0] = '0' + @intCast(u8, hours / 10);
    buf[1] = '0' + @intCast(u8, hours % 10);
    buf[2] = ':';
    buf[3] = '0' + @intCast(u8, minutes / 10);
    buf[4] = '0' + @intCast(u8, minutes % 10);
    buf[5] = ':';
    buf[6] = '0' + @intCast(u8, secs / 10);
    buf[7] = '0' + @intCast(u8, secs % 10);
    return buf;
}

fn parseTime(text: []const u8) u64 {
    const hours: u64 = @intCast(text[0] - '0') * 10 + @intCast(text[1] - '0');
    const minutes: u64 = @intCast(text[3] - '0') * 10 + @intCast(text[4] - '0');
    const seconds: u64 = @intCast(text[6] - '0') * 10 + @intCast(text[7] - '0');
    return hours * 3600 + minutes * 60 + seconds;
}

pub const Stopwatch = struct {
    state: StopwatchState,
    current_lap: u64,
    total_time: u64,
    previous_laps: ArrayList([8]u8),
    allocator: mem.Allocator,

    pub fn init(allocator: mem.Allocator) Stopwatch {
        return Stopwatch{
            .state = .ready,
            .current_lap = 0,
            .total_time = 0,
            .previous_laps = ArrayList([8]u8).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Stopwatch) void {
        self.previous_laps.deinit();
    }

    pub fn currentLap(self: *Stopwatch) [8]u8 {
        return formatTime(self.current_lap);
    }

    pub fn previousLaps(self: *Stopwatch) mem.Allocator.Error![][8]u8 {
        const items = self.previous_laps.items;
        const result = try self.allocator.alloc([8]u8, items.len);
        for (items, 0..) |lap, i| {
            result[i] = lap;
        }
        return result;
    }

    pub fn total(self: *Stopwatch) [8]u8 {
        return formatTime(self.total_time);
    }

    pub fn start(self: *Stopwatch) StopwatchError!void {
        switch (self.state) {
            .ready, .stopped => {
                self.state = .running;
            },
            .running => return StopwatchError.AlreadyRunning,
        }
    }

    pub fn stop(self: *Stopwatch) StopwatchError!void {
        switch (self.state) {
            .running => {
                self.state = .stopped;
            },
            else => return StopwatchError.NotRunning,
        }
    }

    pub fn reset(self: *Stopwatch) StopwatchError!void {
        switch (self.state) {
            .stopped => {
                self.state = .ready;
                self.current_lap = 0;
                self.total_time = 0;
                self.previous_laps.clearRetainingCapacity();
            },
            else => return StopwatchError.NotStopped,
        }
    }

    pub fn advanceTime(self: *Stopwatch, by: []const u8) !void {
        if (self.state != .running) return;
        const seconds = parseTime(by);
        self.current_lap += seconds;
        self.total_time += seconds;
    }

    pub fn lap(self: *Stopwatch) (mem.Allocator.Error || StopwatchError)!void {
        if (self.state != .running) return StopwatchError.NotRunning;
        try self.previous_laps.append(formatTime(self.current_lap));
        self.current_lap = 0;
    }
};
