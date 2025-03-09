const std = @import("std");

pub const EnvEntry = struct {
    key: []const u8,
    value: []const u8,
};

pub fn load(allocator: std.mem.Allocator, file_path: []const u8) !std.StringHashMap([]const u8) {
    const fs = std.fs.cwd();
    const file = fs.openFile(file_path, .{}) catch unreachable;
    defer file.close();

    const file_info = try file.stat();
    const file_size = file_info.size;

    const contents = try allocator.alloc(u8, file_size);

    _ = file.readAll(contents) catch unreachable;

    return parse(allocator, contents);
}

pub fn parse(allocator: std.mem.Allocator, contents: []const u8) !std.StringHashMap([]const u8) {
    var envMap = std.StringHashMap([]const u8).init(allocator);

    var lineIterator = std.mem.splitScalar(u8, contents, '\n');
    while (lineIterator.next()) |line| {
        const maybeEnvEntry = try parseLine(line);
        if (maybeEnvEntry != null) {
            const envEntry = maybeEnvEntry.?;
            try envMap.put(envEntry.key, envEntry.value);
        }
    }

    return envMap;
}

pub fn parseLine(line: []const u8) !?EnvEntry {
    const trimmed = std.mem.trim(u8, line, " \t\n\r");

    //empty line or comment line
    if (trimmed.len == 0 or trimmed[0] == '#') {
        return null;
    }

    const eql_pos = std.mem.indexOf(u8, trimmed, "=") orelse return error.MissingEqualSign;

    const key = std.mem.trim(u8, trimmed[0..eql_pos], " \n");
    const value = std.mem.trim(u8, trimmed[eql_pos + 1 ..], " \n");

    return EnvEntry{
        .key = key,
        .value = value,
    };
}
