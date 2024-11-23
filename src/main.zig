const std = @import("std");

const Token = struct {
    name: []const u8,
    kind: []const u8,
    value: []const u8,
    line_number: i32,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alc = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const f: std.fs.File = try std.fs.openFileAbsolute("/Users/tymalik/Documents/git/markdown_parser_zig/src/test.md", .{ .mode = .read_only });
    defer f.close();

    var br = std.io.bufferedReader(f.reader());
    var r = br.reader();

    var l = std.ArrayList(u8).init(alc);
    defer l.deinit();

    var lc: usize = 0;
    while (true) {
        r.streamUntilDelimiter(l.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        lc += 1;
        std.debug.print("line_number: {d}\n", .{lc});
        l.clearRetainingCapacity();
    }
}
