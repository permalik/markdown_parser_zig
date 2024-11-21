const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    // const bytes = try allocator.alloc(u8, 8);
    // defer allocator.free(bytes);

    const f: std.fs.File = try std.fs.openFileAbsolute("/Users/tymalik/Documents/git/markdown_parser_zig/src/test.md", .{ .mode = .read_only });
    defer f.close();

    try read_line(f, allocator);
}

pub fn read_line(f: std.fs.File, allocator: std.mem.Allocator) !void {
    var buffered = std.io.bufferedReader(f.reader());
    var reader = buffered.reader();

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    var line_number: usize = 0;
    var byte_count: usize = 0;
    while (true) {
        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        line_number += 1;
        std.debug.print("line_number: {d}\n", .{line_number});
        byte_count += arr.items.len;
        arr.clearRetainingCapacity();
    }
    std.debug.print("{d} lines, {d} bytes", .{ line_number, byte_count });
}
