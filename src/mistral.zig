const std = @import("std");
const beepboop = @import("request.zig");

pub fn requestPOST(api_key: []const u8) !void {
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

    const uri = try std.Uri.parse("https://api.mistral.ai/v1/ocr");

    const bearer_string = try std.fmt.allocPrint(allocator, "Bearer {s}", .{api_key});
    defer allocator.free(bearer_string);
    const headers = std.http.Client.Request.Headers{ .authorization = std.http.Client.Request.Headers.Value{
        .override = bearer_string,
    } };

    const response = beepboop.POST(uri, headers, data);
    std.debug.print("{!s}", .{response});
}

pub fn listFiles(api_key: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const uri = try std.Uri.parse("https://api.mistral.ai/v1/files");

    const bearer_string = try std.fmt.allocPrint(allocator, "Bearer {s}", .{api_key});
    defer allocator.free(bearer_string);
    const headers = std.http.Client.Request.Headers{ .authorization = std.http.Client.Request.Headers.Value{
        .override = bearer_string,
    } };
    const response = beepboop.GET(uri, headers);
    std.debug.print("{!s}\n", .{response});
}

pub fn listModels(api_key: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const uri = try std.Uri.parse("https://api.mistral.ai/v1/models");

    const bearer_string = try std.fmt.allocPrint(allocator, "Bearer {s}", .{api_key});
    defer allocator.free(bearer_string);
    const headers = std.http.Client.Request.Headers{ .authorization = std.http.Client.Request.Headers.Value{
        .override = bearer_string,
    } };
    const response = beepboop.GET(uri, headers);
    std.debug.print("{!s}\n", .{response});
}
