const std = @import("std");
const mem = std.mem;

pub const Node = struct {
    data: i32,
    left: ?*Node,
    right: ?*Node,
};

pub const Tree = struct {
    allocator: mem.Allocator,
    root: ?*Node,

    pub fn init(allocator: mem.Allocator) Tree {
        return Tree{
            .allocator = allocator,
            .root = null,
        };
    }

    pub fn deinit(self: *Tree) void {
        freeNode(self.allocator, self.root);
    }

    pub fn insert(self: *Tree, data: i32) mem.Allocator.Error!void {
        var node = try self.allocator.alloc(Node);
        node.* = Node{
            .data = data,
            .left = null,
            .right = null,
        };

        if (self.root) |root| {
            var cur: *Node = root;
            while (true) {
                if (data <= cur.data) {
                    if (cur.left) |left| {
                        cur = left;
                    } else {
                        cur.left = node;
                        break;
                    }
                } else {
                    if (cur.right) |right| {
                        cur = right;
                    } else {
                        cur.right = node;
                        break;
                    }
                }
            }
        } else {
            self.root = node;
        }
    }

    pub fn sortedData(self: *const Tree, allocator: mem.Allocator) mem.Allocator.Error![]i32 {
        var list = std.ArrayList(i32).init(allocator);
        defer list.deinit();

        fn walk(node: ?*Node) void!void {
            if (node) |n| {
                try walk(n.left);
                try list.append(n.data);
                try walk(n.right);
            }
        }

        try walk(self.root);
        return list.toOwnedSlice();
    }
};

fn freeNode(allocator: mem.Allocator, node: ?*Node) void {
    if (node) |n| {
        freeNode(allocator, n.left);
        freeNode(allocator, n.right);
        allocator.free(node);
    }
}
