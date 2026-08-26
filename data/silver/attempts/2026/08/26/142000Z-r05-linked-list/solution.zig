pub fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node = null,
            next: ?*Node = null,
            data: T,
        };

        first: ?*Node = null,
        last: ?*Node = null,
        len: usize = 0,

        pub fn push(self: *@This(), node: *Node) void {
            node.prev = self.last;
            node.next = null;
            if (self.last) |l| {
                l.next = node;
            } else {
                self.first = node;
            }
            self.last = node;
            self.len += 1;
        }

        pub fn pop(self: *@This()) ?*Node {
            const last_node = self.last orelse return null;
            const prev = last_node.prev;
            if (prev) |p| {
                p.next = null;
            } else {
                self.first = null;
            }
            self.last = prev;
            self.len -= 1;
            return last_node;
        }

        pub fn shift(self: *@This()) ?*Node {
            const first_node = self.first orelse return null;
            const next = first_node.next;
            if (next) |n| {
                n.prev = null;
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
            if (self.first) |f| {
                f.prev = node;
            } else {
                self.last = node;
            }
            self.first = node;
            self.len += 1;
        }

        pub fn delete(self: *@This(), node: *Node) void {
            // Check if node is actually in this list by traversing from first.
            var current = self.first;
            while (current) |cur| {
                if (cur == node) {
                    // Node found – perform deletion.
                    if (node.prev) |p| {
                        p.next = node.next;
                    } else {
                        self.first = node.next;
                    }
                    if (node.next) |n| {
                        n.prev = node.prev;
                    } else {
                        self.last = node.prev;
                    }
                    self.len -= 1;
                    return;
                }
                current = cur.next;
            }
            // Node not found – do nothing.
        }
    };
}
