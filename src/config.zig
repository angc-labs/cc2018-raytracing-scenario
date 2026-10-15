const rl = @import("raylib");
const Forma = @import("objetos/forma.zig").Forma;
pub const Light = @import("raytracer.zig").Light;
pub const LightType = @import("raytracer.zig").LightType;
const Material = @import("materiales/material.zig").Material;

pub const materiales = @import("materiales/mod.zig");
pub const objetos = @import("objetos/mod.zig");

// ============================================================================
// materiales (re-exportados desde src/materiales)
// ============================================================================

pub const espejo = materiales.espejo;
pub const vidrio = materiales.vidrio;
pub const diamante = materiales.diamante;
pub const marmol = materiales.marmol;
pub const suelo = materiales.suelo;
pub const rojo = materiales.rojo;
pub const alabastro = materiales.alabastro;
pub const lampara = materiales.lampara;
pub const crear_lampara = materiales.crear_lampara;

// ============================================================================
// objetos de la escena (re-exportados desde src/objetos)
// ============================================================================

pub const objects = objetos.objects;
pub const spheres = objetos.spheres;

// ============================================================================
// luces
// ============================================================================

pub const lights = [_]Light{
    .{
        .Color = .{ .x = 1.0, .y = 0.0, .z = 0.0 },
        .Intensity = 1,
        .Position = .{ .x = 5, .y = 100, .z = 15 },
    },
    .{
        .Color = .{ .x = 1.0, .y = 1.0, .z = 1.0 },
        .Intensity = 1,
        .Position = .{ .x = 0, .y = 0, .z = -250 },
    },
    // luz emitida por la lampara
    .{
        .Color = .{ .x = 1.0, .y = 0.9, .z = 0.4 },
        .Intensity = 1.5,
        .Position = .{ .x = 5, .y = 10, .z = -25 },
    },
    // luz direccional (simula el sol con rayos paralelos)
    Light.direccional(.{ .x = -0.3, .y = -1.0, .z = -0.5 }, .{ .x = 1.0, .y = 1.0, .z = 0.9 }, 0.8),
};
