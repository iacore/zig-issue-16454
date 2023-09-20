const std = @import("std");

pub fn getExternList(comptime Type: type) []const []const u8 {
    const Sorter = struct {
        pub fn lessThan(_: void, lhs: []const u8, rhs: []const u8) bool {
            return std.ascii.orderIgnoreCase(lhs, rhs) == std.math.Order.lt;
        }
    };
    var extern_list = Type.Extern;
    std.sort.block([]const u8, &extern_list, void{}, Sorter.lessThan);
    return &extern_list;
}

const t0 = getExternList(struct {
    pub const Extern = [_][]const u8{ "z", "hey", "hi", "yooo" };
})[0];

test {
    try std.testing.expectEqual(@as([]const u8, "hey"), t0);
}
