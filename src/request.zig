const std = @import("std");

pub fn requestPOST(apiKey: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const data = .{
        .model = "Ziguana",
        .id = "1234",
        .document = .{
            .type = "document_url",
            .document_url = "https://example.com/document.pdf",
            .document_name = "document.pdf",
        },
        .pages = &[_]u32{0},
        .include_image_base64 = true,
        .image_limit = 0,
        .image_min_size = 0,
    };
    var json_string = std.ArrayList(u8).init(allocator);
    defer json_string.deinit();
    try std.json.stringify(data, .{}, json_string.writer());

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();
    var buf: [2048]u8 = undefined;
    const uri = try std.Uri.parse("https://api.mistral.ai/v1/ocr");

    const extra_headers = [_]std.http.Header{
        .{ .name = "ApiKey", .value = apiKey },
    };

    var request = try client.open(.POST, uri, .{
        .server_header_buffer = &buf,
        .extra_headers = &extra_headers,
    });
    defer request.deinit();
    request.transfer_encoding = .chunked;
    try request.send();
    try request.writeAll(json_string.items);
    try request.finish();
    try request.wait();

    // Reading the response
    const body = try request.reader().readAllAlloc(allocator, 256);
    std.debug.print("{s}\n", .{body});
}
