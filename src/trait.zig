// Implementing the functions used in zigtrait
// https://github.com/wrongnull/zigtrait/
// TODO: understand the code more so to maybe remove this

pub const TraitFn = fn (type) callconv(.Inline) bool;

pub inline fn isContainer(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .Struct, .Union, .Enum, .Opaque => true,
        else => false,
    };
}

pub fn hasFn(comptime name: []const u8) TraitFn {
    const Closure = struct {
        pub inline fn trait(comptime T: type) bool {
            if (!comptime isContainer(T)) return false;
            if (!comptime @hasDecl(T, name)) return false;
            const DeclType = @TypeOf(@field(T, name));
            return @typeInfo(DeclType) == .Fn;
        }
    };
    return Closure.trait;
}
