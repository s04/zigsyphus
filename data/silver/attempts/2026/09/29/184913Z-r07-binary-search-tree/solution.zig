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
        return Tree{
            .root = null,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Tree) void {
        if (self.root) |root| {
            deinitNode(self.allocator, root);
        }
        self.root = null;
    }

    fn deinitNode(allocator: mem.Allocator, node: *Node) void {
        if (node.left) |left| {
            deinitNode(allocator, left);
        }
        if (node.right) |right| {
            deinitNode(allocator, right);
        }
        allocator.destroy(node);
    }

    pub fn insert(self: *Tree, data: i32) mem.Allocator.Error!void {
        if (self.root) |root| {
            try insertNode(self.allocator, root, data);
        } else {
            const node = try self.allocator.create(Node);
            node.* = Node{
                .data = data,
                .left = null,
                .right = null,
            };
            self.root = node;
        }
    }

    fn insertNode(allocator: mem.Allocator, node: *Node, data: i32) mem.Allocator.Error!void {
        if (data <= node.data) {
            if (node.left) |left| {
                try insertNode(allocator, left, data);
            } else {
                const new_node = try allocator.create(Node);
                new_node.* = Node{
                    .data = data,
                    .left = null,
                    .right = null,
                };
                node.left = new_node;
            }
        } else {
            if (node.right) |right| {
                try insertNode(allocator, right, data);
            } else {
                const new_node = try allocator.create(Node);
                new_node.* = Node{
                    .data = data,
                    .left = null,
                    .right = null,
                };
                node.right = new_node;
            }
        }
    }

    pub fn sortedData(self: *const Tree, allocator: mem.Allocator) mem.Allocator.Error![]i32 {
        var list = std.ArrayList(i32).init(allocator);
        errdefer list.deinit();

        if (self.root) |root| {
            try collectSorted(root, &list);
        }

        return list.toOwnedSlice();
    }

    fn collectSorted(node: *Node, list: *std.ArrayList(i32)) mem.Allocator.Error!void {
        if (node.left) |left| {
            try collectSorted(left, list);
        }
        try list.append(node.data);
        if (node.right) |right| {
            try collectSorted(right, list);
        }
    }
};
