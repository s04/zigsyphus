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
        const count = countNodes(self.root);
        const result = try allocator.alloc(i32, count);
        var index: usize = 0;
        fillSortedData(self.root, result, &index);
        return result;
    }

    fn countNodes(node: ?*Node) usize {
        if (node) |n| {
            return 1 + countNodes(n.left) + countNodes(n.right);
        }
        return 0;
    }

    fn fillSortedData(node: ?*Node, result: []i32, index: *usize) void {
        if (node) |n| {
            fillSortedData(n.left, result, index);
            result[index.*] = n.data;
            index.* += 1;
            fillSortedData(n.right, result, index);
        }
    }
};
