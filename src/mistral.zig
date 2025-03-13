const std = @import("std");
const beepboop = @import("request.zig");
const filez = @import("file.zig");

pub fn requestPOST(api_key: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    //    const file_binary = filez.getFileBinary(allocator, "test.txt");

    const data = .{};

    const uri = try std.Uri.parse("https://api.mistral.ai/v1/ocr");

    const bearer_string = try std.fmt.allocPrint(allocator, "Bearer {s}", .{api_key});
    defer allocator.free(bearer_string);
    const headers = std.http.Client.Request.Headers{ .authorization = std.http.Client.Request.Headers.Value{
        .override = bearer_string,
    } };

    const response = beepboop.POST(uri, headers, data);
    std.debug.print("{!s}", .{response});
}

pub fn ocr(api_key: []const u8) ![]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const data = .{
        .model = "mistral-ocr-latest",
        .document = .{
            .type = "document_url",
            .document_url = "https://s28.q4cdn.com/392171258/files/doc_downloads/test.pdf",
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

    const response = beepboop.POST(uri, headers, data);
    return response;
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
