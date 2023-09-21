const std = @import("std");
const builtin = @import("builtin");

pub fn getExternList(comptime Type: type) []const []const u8 {
    const Sorter = struct {
        abc: type,
        pub fn lessThan(comptime _: @This(), lhs: []const u8, rhs: []const u8) bool {
            return std.ascii.orderIgnoreCase(lhs, rhs) == std.math.Order.lt;
        }
    };
    var extern_list = Type.Extern;
    block([]const u8, &extern_list, Sorter{ .abc = Type }, Sorter.lessThan);
    return &extern_list;
}

const t0 = getExternList(struct {
    pub const Extern = [_][]const u8{ "z", "hey", "hi", "yooo" };
})[0];

test {
    _ = t0;
    // try std.testing.expectEqualSlices(u8, @as([]const u8, "hey"), t0);
}

// std.sort.block extracted here
pub fn block(
    comptime T: type,
    items: []T,
    context: anytype,
    comptime lessThanFn: fn (@TypeOf(context), lhs: T, rhs: T) bool,
) void {
    @compileLog(@TypeOf(lessThanFn));
    _ = items;
    const is_ctx_comptime = true;
    // const is_ctx_comptime = @typeInfo(@TypeOf(lessThanFn)).Fn.params[0].is_comptime;

    const lessThan = if (builtin.mode == .Debug)
        if (is_ctx_comptime) struct {
            fn lessThan(comptime ctx: @TypeOf(context), lhs: T, rhs: T) bool {
                const lt = lessThanFn(ctx, lhs, rhs);
                const gt = lessThanFn(ctx, rhs, lhs);
                std.debug.assert(!(lt and gt));
                return lt;
            }
        }.lessThan else struct {
            fn lessThan(ctx: @TypeOf(context), lhs: T, rhs: T) bool {
                const lt = lessThanFn(ctx, lhs, rhs);
                const gt = lessThanFn(ctx, rhs, lhs);
                std.debug.assert(!(lt and gt));
                return lt;
            }
        }.lessThan
    else
        lessThanFn;
    _ = lessThan;
}
