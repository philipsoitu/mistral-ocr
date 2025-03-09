const std = @import("std");
const dotenv = @import("dotenv.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    _ = try dotenv.load(allocator, ".env");
}
