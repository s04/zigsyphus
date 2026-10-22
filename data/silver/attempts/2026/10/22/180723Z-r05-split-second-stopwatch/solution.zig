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
    allocator: mem.Allocator,
    current_lap: [8]u8,
    total_time: [8]u8,
    previous_laps: std.ArrayList([8]u8),

    pub fn init(allocator: mem.Allocator) Stopwatch {
        var sw = Stopwatch{
            .state = .ready,
            .allocator = allocator,
            .current_lap = "00:00:00",
            .total_time = "00:00:00",
            .previous_laps = std.ArrayList([8]u8).init(allocator),
        };
        return sw;
    }

    pub fn deinit(self: *Stopwatch) void {
        self.previous_laps.deinit();
    }

    pub fn currentLap(self: *Stopwatch) [8]u8 {
        return self.current_lap;
    }

    pub fn previousLaps(self: *Stopwatch) mem.Allocator.Error![][8]u8 {
        return try self.previous_laps.toOwnedSlice();
    }

    pub fn total(self: *Stopwatch) [8]u8 {
        return self.total_time;
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
        self.current_lap = "00:00:00";
        self.total_time = "00:00:00";
        self.previous_laps.clearAndFree();
    }

    pub fn advanceTime(self: *Stopwatch, by: []const u8) !void {
        if (self.state != .running) {
            return;
        }
        const parts = try std.mem.splitOwned(self.allocator, by, ":");
        defer {
            for (parts) |part| {
                self.allocator.free(part);
            }
        }
        var minutes: u32 = 0;
        var seconds: u32 = 0;
        var hundredths: u32 = 0;
        var i: usize = 0;
        for (parts) |part| : (i += 1) {
            const val = std.fmt.parseInt(u32, part, 10) catch 0;
            if (i == 0) {
                minutes = val;
            } else if (i == 1) {
                seconds = val;
            } else if (i == 2) {
                hundredths = val;
            }
        }
        const current_ms = self.timeToMs(&self.current_lap);
        const add_ms = minutes * 6000 + seconds * 100 + hundredths;
        const new_ms = current_ms + add_ms;
        self.msToTime(new_ms, &self.current_lap);
        self.msToTime(self.timeToMs(&self.total_time) + add_ms, &self.total_time);
    }

    fn timeToMs(self: *Stopwatch, time: *[8]u8) u32 {
        _ = self;
        const minutes = std.fmt.parseInt(u32, time[0..2], 10) catch 0;
        const seconds = std.fmt.parseInt(u32, time[3..5], 10) catch 0;
        const hundredths = std.fmt.parseInt(u32, time[6..8], 10) catch 0;
        return minutes * 6000 + seconds * 100 + hundredths;
    }

    fn msToTime(self: *Stopwatch, ms: u32, out: *[8]u8) void {
        _ = self;
        const minutes = ms / 6000;
        const remaining = ms % 6000;
        const seconds = remaining / 100;
        const hundredths = remaining % 100;
        out.* = try std.fmt.bufPrint(out, "{d:02}:{d:02}:{d:02}", .{ minutes, seconds, hundredths });
    }

    pub fn lap(self: *Stopwatch) (mem.Allocator.Error || StopwatchError)!void {
        if (self.state != .running) {
            return error.NotRunning;
        }
        try self.previous_laps.append(self.current_lap);
        self.current_lap = "00:00:00";
    }
};
