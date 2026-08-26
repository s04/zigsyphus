pub fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last: ?*Node,
        len: usize,

        pub fn push(self: *@This(), node: *Node) void {
            node.prev = self.last;
            node.next = null;
            if (self.last) {
                self.last.next = node;
            } else {
                self.first = node;
            }
            self.last = node;
            self.len += 1;
        }

        pub fn pop(self: *@This()) ?*Node {
            const last_node = self.last;
            if (last_node) == null {
                return null;
            }
            const prev = last_node.prev;
            if (prev) {
                prev.next = null;
            } else {
                self.first = null;
            }
            self.last = prev;
            self.len -= 1;
            return last_node;
        }

        pub fn shift(self: *@This()) ?*Node {
            const first_node = self.first;
            if (first_node) == null {
                return null;
            }
            const next = first_node.next;
            if (next) {
                next.prev = null;
            } else {
                self.last = null;
            }
            self.first = next;
            self.len -= 1;
            return first_node;
        }

        pub fn unshift(self: *@This(), node: *Node) void {
            node.prev = null;
            node.next = self.first;
            if (self.first) {
                self.first.prev = node;
            } else {
                self.last = node;
            }
            self.first = node;
            self.len += 1;
        }

        pub fn delete(self: *@This(), node: *Node) void {
            if (node.prev) {
                node.prev.next = node.next;
            } else {
                self.first = node.next;
            }
            if (node.next) {
                node.next.prev = node.prev;
            } else {
                self.last = node.prev;
            }
            self.len -= 1;
        }
    };
}
