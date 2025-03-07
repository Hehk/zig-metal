const std = @import("std");

pub const Package = struct {
    module: *std.Build.Module,

    pub fn link(pkg: Package, exe: *std.Build.Step.Compile) void {
        exe.root_module.addImport("zig-metal", pkg.module);
    }
};

pub fn addExample(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    comptime name: []const u8,
    comptime path: []const u8,
) void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path(path ++ "/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
    const module = b.createModule(.{ .root_source_file = b.path("src/main.zig") });
    exe.root_module.addImport("zig-metal", module);

    exe.linkFramework("Foundation");
    exe.linkFramework("AppKit");
    exe.linkFramework("Metal");
    exe.linkFramework("MetalKit");

    const run_cmd = b.addRunArtifact(exe);

    const run_step = b.step("run-" ++ name, "Run the sample '" ++ name ++ "'");
    run_step.dependOn(&run_cmd.step);
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    addExample(b, target, optimize, "window", "examples/01-window");
    addExample(b, target, optimize, "primitive", "examples/02-primitive");
    addExample(b, target, optimize, "argbuffers", "examples/03-argbuffers");
    addExample(b, target, optimize, "animation", "examples/04-animation");
    addExample(b, target, optimize, "instancing", "examples/05-instancing");
    addExample(b, target, optimize, "perspective", "examples/06-perspective");
    addExample(b, target, optimize, "lighting", "examples/07-lighting");
    addExample(b, target, optimize, "texturing", "examples/08-texturing");
    addExample(b, target, optimize, "compute", "examples/09-compute");
    addExample(b, target, optimize, "compute-to-render", "examples/10-compute_to_render");
}
