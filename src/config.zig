const rl = @import("raylib");
const Forma = @import("objetos/forma.zig").Forma;
const Light = @import("raytracer.zig").Light;
const Material = @import("materiales/material.zig").Material;
const htmlColor = @import("cute_colors.zig").htmlColor;
const V3FromColor = @import("raytracer.zig").V3FromColor;

pub const materiales = @import("materiales/mod.zig");
pub const objetos = @import("objetos/mod.zig");

// ============================================================================
// MATERIALES (Re-exportados desde src/materiales)
// ============================================================================

pub const espejo = materiales.espejo;
pub const vidrio = materiales.vidrio;
pub const diamante = materiales.diamante;
pub const marmol = materiales.marmol;
pub const suelo = materiales.suelo;
pub const rojo = materiales.rojo;

// ============================================================================
// OBJETOS DE LA ESCENA (Re-exportados desde src/objetos)
// ============================================================================

pub const objects = objetos.objects;
pub const spheres = objetos.spheres;

// ============================================================================
// LUCES
// ============================================================================

pub const lights = [_]Light{
    .{
        .Color = V3FromColor(htmlColor("#f00")),
        .Intensity = 1,
        .Position = .{ .x = 5, .y = 100, .z = 15 },
    },
    .{
        .Color = V3FromColor(htmlColor("#fff")),
        .Intensity = 1,
        .Position = .{ .x = 0, .y = 0, .z = -250 },
    },
};
