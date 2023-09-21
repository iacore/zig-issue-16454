const std = @import("std");

const Foo = struct {};

const Fn_comptime = fn (comptime type) void;
const Fn_nocomptime = fn (Foo) void;

fn fn_comptime(comptime _: type) void {}
fn fn_nocomptime(_: Foo) void {}

// const StillFoo = (comptime Foo); // not allowed
// fn fn_what(_: StillFoo) void {}

fn callme(
    comptime T: type,
    comptime f: fn (T) void,
) void {
    @compileLog(@typeInfo(@TypeOf(f)).Fn.params[0]);
}

test {
    callme(type, fn_comptime);
    callme(Foo, fn_nocomptime);
}
