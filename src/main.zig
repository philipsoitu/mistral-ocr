const std = @import("std");
const dotenv = @import("dotenv.zig");
const mistral = @import("mistral.zig");
const file = @import("file.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    std.debug.print("Loading .env\n", .{});
    var map = try dotenv.load(allocator, ".env");
    defer map.deinit();

    const api_key = map.get("API_KEY") orelse return error.MISSING_API_KEY;

    std.debug.print("api key was loaded\n", .{});

    const contents = try mistral.ocr(api_key, "");
    try file.saveToFile("output/ocr_output.json", contents);
}
