const std = @import("std");

pub fn getFileBinary(allocator: *std.mem.Allocator, filename: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(filename, .{ .read = true });
    defer file.close();
    const file_bin = try file.readToEndAlloc(allocator, std.math.maxInt(u64));
    return file_bin;
}

pub fn saveToFile(file_path: []const u8, contents: []const u8) !void {
    var file = try std.fs.cwd().createFile(file_path, .{});
    try file.writeAll(contents);
    defer file.close();
}
