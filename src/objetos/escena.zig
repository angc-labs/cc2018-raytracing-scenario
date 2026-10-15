const Forma = @import("forma.zig").Forma;
const materiales = @import("../materiales/mod.zig");

// ============================================================================
// objetos de la escena
// ============================================================================

pub const objects = [_]Forma{
    .{ .Plane = .{
        .point = .{ .x = 0, .y = -5, .z = 0 },
        .normal = .{ .x = 0, .y = 1, .z = 0 },
        .material = materiales.suelo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 10, .y = 0, .z = -40 },
        .radius = 5,
        .material = materiales.espejo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 12.5, .y = 0, .z = -60 },
        .radius = 5,
        .material = materiales.rojo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 0, .y = 0, .z = 0 },
        .radius = 5,
        .material = materiales.marmol,
    } },
    // cubo traslucido de alabastro apoyado en el suelo
    .{ .Cube = .{
        .center = .{ .x = -16, .y = -1.5, .z = -15 },
        .size = 7,
        .material = materiales.alabastro,
    } },
    // lampara o sol que brilla
    .{ .Sphere = .{
        .center = .{ .x = 5, .y = 10, .z = -25 },
        .radius = 3.5,
        .material = materiales.lampara,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 22, .y = 0, .z = -45 },
        .radius = 5,
        .material = materiales.espejo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = -25, .y = 0, .z = -40 },
        .radius = 5,
        .material = materiales.vidrio,
    } },
    .{ .Sphere = .{
        .center = .{ .x = -37, .y = 0, .z = -40 },
        .radius = 5,
        .material = materiales.diamante,
    } },
};

// alias por compatibilidad
pub const spheres = objects;
