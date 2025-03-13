const std = @import("std");
const http = std.http;
const dotenv = @import("dotenv.zig");
const mistral = @import("mistral.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    std.debug.print("Loading .env\n", .{});
    var map = try dotenv.load(allocator, ".env");
    defer map.deinit();

    const api_key = map.get("API_KEY") orelse return error.MISSING_API_KEY;

    std.debug.print("api key: {s}\n", .{api_key});
    try mistral.listFiles(api_key);
}
