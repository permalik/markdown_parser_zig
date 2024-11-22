const std = @import("std");

const Token = struct {
    name: []const u8,
    kind: []const u8,
    value: []const u8,
    line_number: i32,
    byte_offset: i32,
};

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

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    try read_line(f, arr);
}

pub fn read_line(f: std.fs.File, arr: std.ArrayListAligned(u8, null)) !void {
    var buffered = std.io.bufferedReader(f.reader());
    var reader = buffered.reader();

    var line_count: usize = 0;
    var byte_count: usize = 0;
    while (true) {
        reader.streamUntilDelimiter(*.arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        line_count += 1;
        std.debug.print("line_number: {d}\n", .{line_count});
        byte_count += *.arr.items.len;
        *.arr.clearRetainingCapacity();
    }
    std.debug.print("{d} lines, {d} bytes", .{ line_count, byte_count });
}
