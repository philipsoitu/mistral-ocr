const std = @import("std");
const request = @import("request.zig");

pub fn ocr(api_key: []const u8, document_url: []const u8) ![]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const data = .{
        .model = "mistral-ocr-latest",
        .document = .{
            .type = "document_url",
            .document_url = document_url,
        },
    };

    const uri = try std.Uri.parse("https://api.mistral.ai/v1/ocr");

    const bearer_string = try std.fmt.allocPrint(allocator, "Bearer {s}", .{api_key});
    defer allocator.free(bearer_string);

    const headers = std.http.Client.Request.Headers{
        .content_type = .{ .override = "application/json" },
        .authorization = std.http.Client.Request.Headers.Value{
            .override = bearer_string,
        },
    };

    const response = request.POST(uri, headers, data);
    return response;
}
