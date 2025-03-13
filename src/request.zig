const std = @import("std");
const http = std.http;

pub fn GET(
    uri: std.Uri,
    headers: http.Client.Request.Headers,
) ![]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    var buf: [4096]u8 = undefined;

    var req = try client.open(.GET, uri, .{
        .server_header_buffer = &buf,
        .headers = headers,
    });
    defer req.deinit();

    try req.send();
    try req.finish();
    try req.wait();

    const body = try req.reader().readAllAlloc(allocator, 65536);
    return body;
}

pub fn POST(
    uri: std.Uri,
    headers: http.Client.Request.Headers,
    data: anytype,
) ![]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var json_string = std.ArrayList(u8).init(allocator);
    defer json_string.deinit();
    try std.json.stringify(data, .{}, json_string.writer());

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();
    var buf: [2048]u8 = undefined;

    var request = try client.open(.POST, uri, .{
        .server_header_buffer = &buf,
        .headers = headers,
    });
    defer request.deinit();
    request.transfer_encoding = .chunked;

    try request.send();
    try request.writeAll(json_string.items);
    try request.finish();
    try request.wait();

    const body = try request.reader().readAllAlloc(allocator, 65536);
    return body;
}
