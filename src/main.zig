const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    // const bytes = try allocator.alloc(u8, 8);
    // defer allocator.free(bytes);

    const f = try std.fs.openFileAbsolute("/Users/tymalik/Documents/git/markdown_parser_zig/src/test.md", .{ .mode = .read_only });
    defer f.close();

    var buffered = std.io.bufferedReader(f.reader());
    var reader = buffered.reader();

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    var byte_count: usize = 0;
    while (true) {
        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        byte_count += arr.items.len;
        arr.clearRetainingCapacity();
    }
    std.debug.print("{d} bytes", .{byte_count});
}
