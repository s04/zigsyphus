const std = @import("std");
const mem = std.mem;

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

pub const Stopwatch = struct {
    state: StopwatchState,
    totalSeconds: u32,
    currentLapSeconds: u32,
    lapTimes: std.ArrayList(u32),
    allocator: mem.Allocator,

    pub fn init(allocator: mem.Allocator) Stopwatch {
        return Stopwatch{
            .state = .ready,
            .totalSeconds = 0,
            .currentLapSeconds = 0,
            .lapTimes = std.ArrayList(u32){ .allocator = allocator, .items = null, .len = 0, .capacity = 0 },
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Stopwatch) void {
        self.lapTimes.deinit(self.allocator);
    }

    pub fn currentLap(self: *Stopwatch) [8]u8 {
        return formatTime(self.currentLapSeconds);
    }

    pub fn previousLaps(self: *Stopwatch) mem.Allocator.Error![][8]u8 {
        var result = try std.ArrayList([8]u8).initCapacity(self.allocator, self.lapTimes.items.len);
        defer result.deinit(self.allocator);

        for (self.lapTimes.items) |lapTime| {
            try result.append(self.allocator, formatTime(lapTime));
        }

        return result.toOwnedSlice(self.allocator);
    }

    pub fn total(self: *Stopwatch) [8]u8 {
        return formatTime(self.totalSeconds);
    }

    pub fn start(self: *Stopwatch) StopwatchError!void {
        if (self.state == .running) {
            return error.AlreadyRunning;
        }
        self.state = .running;
    }

    pub fn stop(self: *Stopwatch) StopwatchError!void {
        if (self.state != .running) {
            return error.NotRunning;
        }
        self.state = .stopped;
    }

    pub fn reset(self: *Stopwatch) StopwatchError!void {
        if (self.state != .stopped) {
            return error.NotStopped;
        }
        self.state = .ready;
        self.totalSeconds = 0;
        self.currentLapSeconds = 0;
        self.lapTimes.clearAndFree(self.allocator);
    }

    pub fn advanceTime(self: *Stopwatch, by: []const u8) !void {
        if (self.state != .running) {
            return error.NotRunning;
        }
        const seconds = parseTime(by);
        self.totalSeconds += seconds;
        self.currentLapSeconds += seconds;
    }

    pub fn lap(self: *Stopwatch) (mem.Allocator.Error || StopwatchError)!void {
        if (self.state != .running) {
            return error.NotRunning;
        }
        try self.lapTimes.append(self.allocator, self.currentLapSeconds);
        self.currentLapSeconds = 0;
    }
};

fn formatTime(seconds: u32) [8]u8 {
    var result: [8]u8 = undefined;
    const hours = seconds / 3600;
    const minutes = (seconds % 3600) / 60;
    const secs = seconds % 60;

    result[0] = '0' + @intCast(u8, hours / 10);
    result[1] = '0' + @intCast(u8, hours % 10);
    result[2] = ':';
    result[3] = '0' + @intCast(u8, minutes / 10);
    result[4] = '0' + @intCast(u8, minutes % 10);
    result[5] = ':';
    result[6] = '0' + @intCast(u8, secs / 10);
    result[7] = '0' + @intCast(u8, secs % 10);

    return result;
}

fn parseTime(s: []const u8) u32 {
    var parts = std.mem.split(u8, s, ':');
    const hours_str = parts.next() orelse "";
    const minutes_str = parts.next() orelse "";
    const seconds_str = parts.next() orelse "";
    const hours = std.fmt.parseInt(u32, hours_str, 10) catch 0;
    const minutes = std.fmt.parseInt(u32, minutes_str, 10) catch 0;
    const seconds = std.fmt.parseInt(u32, seconds_str, 10) catch 0;
    return hours * 3600 + minutes * 60 + seconds;
}
