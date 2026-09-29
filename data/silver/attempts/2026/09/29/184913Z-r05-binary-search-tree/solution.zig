const std = @import("std");
const mem = std.mem;

pub const Node = struct {
    data: i32,
    left: ?*Node = null,
    right: ?*Node = null,
};

pub const Tree = struct {
    root: ?*Node = null,
    allocator: mem.Allocator,

    pub fn init(allocator: mem.Allocator) Tree {
        return Tree{
            .root = null,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Tree) void {
        self.freeNode(self.root);
        self.root = null;
    }

    fn freeNode(self: *Tree, node: ?*Node) void {
        if (node) |n| {
            self.freeNode(n.left);
            self.freeNode(n.right);
            self.allocator.destroy(n);
        }
    }

    pub fn insert(self: *Tree, data: i32) mem.Allocator.Error!void {
        const new_node = try self.allocator.create(Node);
        new_node.* = Node{
            .data = data,
            .left = null,
            .right = null,
        };

        if (self.root) |root_node| {
            self.insertNode(root_node, new_node);
        } else {
            self.root = new_node;
        }
    }

    fn insertNode(self: *Tree, current: *Node, new_node: *Node) void {
        if (new_node.data <= current.data) {
            if (current.left) |left_node| {
                self.insertNode(left_node, new_node);
            } else {
                current.left = new_node;
            }
        } else {
            if (current.right) |right_node| {
                self.insertNode(right_node, new_node);
            } else {
                current.right = new_node;
            }
        }
    }

    pub fn sortedData(self: *const Tree, allocator: mem.Allocator) mem.Allocator.Error![]i32 {
        const node_count = self.count();
        const result = try allocator.alloc(i32, node_count);
        var index: usize = 0;
        self.collect(&result, &index);
        return result;
    }

    fn count(self: *const Tree) usize {
        return self.countNode(self.root);
    }

    fn countNode(self: *const Tree, node: ?*Node) usize {
        if (node) |n| {
            return 1 + self.countNode(n.left) + self.countNode(n.right);
        } else {
            return 0;
        }
    }

    fn collect(self: *const Tree, result: []i32, index: *usize) void {
        if (self.root) |root_node| {
            self.collectNode(root_node, result, index);
        }
    }

    fn collectNode(self: *const Tree, node: *Node, result: []i32, index: *usize) void {
        if (node.left) |left_node| {
            self.collectNode(left_node, result, index);
        }
        result[index.*] = node.data;
        index.* += 1;
        if (node.right) |right_node| {
            self.collectNode(right_node, result, index);
        }
    }
};
