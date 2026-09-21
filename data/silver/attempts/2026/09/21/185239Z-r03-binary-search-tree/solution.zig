const std = @import("std");
const mem = std.mem;

pub const Node = struct {
    data: i32,
    left: ?*Node,
    right: ?*Node,
};

pub const Tree = struct {
    root: ?*Node,
    allocator: mem.Allocator,

    pub fn init(allocator: mem.Allocator) Tree {
        return Tree{ .root = null, .allocator = allocator };
    }

    pub fn deinit(self: *Tree) void {
        deinitNodes(self.allocator, self.root);
        self.root = null;
    }

    fn deinitNodes(allocator: mem.Allocator, node: ?*Node) void {
        if (node) |n| {
            deinitNodes(allocator, n.left);
            deinitNodes(allocator, n.right);
            allocator.destroy(n);
        }
    }

    pub fn insert(self: *Tree, data: i32) mem.Allocator.Error!void {
        if (self.root) |root| {
            try insertNode(self.allocator, root, data);
        } else {
            self.root = try self.allocator.create(Node);
            self.root.?.* = Node{ .data = data, .left = null, .right = null };
        }
    }

    fn insertNode(allocator: mem.Allocator, node: *Node, data: i32) mem.Allocator.Error!void {
        if (data <= node.data) {
            if (node.left) |left| {
                try insertNode(allocator, left, data);
            } else {
                node.left = try allocator.create(Node);
                node.left.?.* = Node{ .data = data, .left = null, .right = null };
            }
        } else {
            if (node.right) |right| {
                try insertNode(allocator, right, data);
            } else {
                node.right = try allocator.create(Node);
                node.right.?.* = Node{ .data = data, .left = null, .right = null };
            }
        }
    }

    pub fn sortedData(self: *const Tree, allocator: mem.Allocator) mem.Allocator.Error![]i32 {
        var result = std.ArrayList(i32).init(allocator);
        try sortedDataHelper(self.root, &result);
        return result.toOwnedSlice();
    }

    fn sortedDataHelper(node: ?*Node, result: *std.ArrayList(i32)) !void {
        if (node) |n| {
            try sortedDataHelper(n.left, result);
            try result.append(n.data);
            try sortedDataHelper(n.right, result);
        }
    }
};
