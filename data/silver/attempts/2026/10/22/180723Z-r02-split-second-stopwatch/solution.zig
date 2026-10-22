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
    current_lap_seconds: u64,
    total_seconds: u64,
    previous_laps: std.ArrayList([8]u8),

    pub fn init(allocator: mem.Allocator) Stopwatch {
        return Stopwatch{
            .state = .ready,
            .allocator = allocator,
            .current_lap_seconds = 0,
            .total_seconds = 0,
            .previous_laps = std.ArrayList([8]u8).init(allocator),
        };
    }

    pub fn deinit(self: *Stopwatch) void {
        self.previous_laps.deinit(self.allocator);
    }

    fn formatTime(seconds: u64) [8]u8 {
        const h = seconds / 3600;
        const m = (seconds % 3600) / 60;
        const s = seconds % 60;
        var buf: [8]u8 = undefined;
        _ = std.fmt.bufPrint(&buf, "{d:0>2}:{d:0>2}:{d:0>2}", .{ h, m, s }) catch unreachable;
        return buf;
    }

    fn parseTime(by: []const u8) !u64 {
        if (by.len != 8) return error.InvalidFormat;
        if (by[2] != ':' or by[5] != ':') return error.InvalidFormat;
        const h = try std.fmt.parseInt(u64, by[0..2], 10);
        const m = try std.fmt.parseInt(u64, by[3..5], 10);
        const s = try std.fmt.parseInt(u64, by[6..8], 10);
        return h * 3600 + m * 60 + s;
    }

    pub fn currentLap(self: *Stopwatch) [8]u8 {
        return formatTime(self.current_lap_seconds);
    }

    pub fn previousLaps(self: *Stopwatch) mem.Allocator.Error![][8]u8 {
        const slice = try self.previous_laps.toOwnedSlice(self.allocator);
        return slice;
    }

    pub fn total(self: *Stopwatch) [8]u8 {
        return formatTime(self.total_seconds);
    }

    pub fn start(self: *Stopwatch) StopwatchError!void {
        if (self.state == .running) {
            return StopwatchError.AlreadyRunning;
        }
        self.state = .running;
    }

    pub fn stop(self: *Stopwatch) StopwatchError!void {
        if (self.state != .running) {
            return StopwatchError.NotRunning;
        }
        self.state = .stopped;
    }

    pub fn reset(self: *Stopwatch) StopwatchError!void {
        if (self.state != .stopped) {
            return StopwatchError.NotStopped;
        }
        self.state = .ready;
        self.current_lap_seconds = 0;
        self.total_seconds = 0;
        self.previous_laps.clearRetainingCapacity();
    }

    pub fn advanceTime(self: *Stopwatch, by: []const u8) !void {
        const seconds = try parseTime(by);
        if (self.state == .running) {
            self.current_lap_seconds += seconds;
            self.total_seconds += seconds;
        }
    }

    pub fn lap(self: *Stopwatch) (mem.Allocator.Error || StopwatchError)!void {
        if (self.state != .running) {
            return StopwatchError.NotRunning;
        }
        try self.previous_laps.append(self.allocator, formatTime(self.current_lap_seconds));
        self.current_lap_seconds = 0;
    }
};
