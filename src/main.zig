const std = @import("std");

fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        gpa.deinit();
    }

    const bytes = try allocator.alloc(u8, 8);
    defer allocator.free(bytes);
}
