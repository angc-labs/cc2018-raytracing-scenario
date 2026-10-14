const rl = @import("raylib");
const Forma = @import("formas.zig").Forma;
const Light = @import("raytracer.zig").Light;
const Material = @import("raytracer.zig").Material;
const htmlColor = @import("cute_colors.zig").htmlColor;
const V3FromColor = @import("raytracer.zig").V3FromColor;

// ============================================================================
// MATERIALES
// ============================================================================

pub const espejo = Material{
    .Color = V3FromColor(htmlColor("#fff")),
    .Propiedades = .{
        .Albedo = 0,
        .Especular = 1,
        .Reflectividad = 0.9,
        .Transparencia = 0,
    },
    .Especular = 100,
    .Refractive_index = 0,
};

pub const vidrio = Material{
    .Color = V3FromColor(htmlColor("#aaa")),
    .Propiedades = .{
        .Albedo = 0,
        .Especular = 0.5,
        .Reflectividad = 0.1,
        .Transparencia = 0.8,
    },
    .Especular = 125,
    .Refractive_index = 1.5,
};

pub const diamante = Material{
    .Color = V3FromColor(htmlColor("#aaa")),
    .Propiedades = .{
        .Albedo = 0,
        .Especular = 0.5,
        .Reflectividad = 0.1,
        .Transparencia = 0.8,
    },
    .Especular = 125,
    .Refractive_index = 2.417,
};

pub const marmol = Material{
    .Color = V3FromColor(htmlColor("#66664c")),
    .Propiedades = .{
        .Albedo = 0.4,
        .Especular = 0.3,
        .Reflectividad = 0,
        .Transparencia = 0,
    },
    .Especular = 10,
    .Refractive_index = 0,
};

pub const suelo = Material{
    .Color = V3FromColor(htmlColor("#4a5568")),
    .Propiedades = .{
        .Albedo = 0.7,
        .Especular = 0.3,
        .Reflectividad = 0.2,
        .Transparencia = 0,
    },
    .Especular = 25,
    .Refractive_index = 0,
};

pub const rojo = Material{
    .Color = V3FromColor(htmlColor("#ff3333")),
    .Propiedades = .{
        .Albedo = 0.85,
        .Especular = 1.0,
        .Reflectividad = 0,
        .Transparencia = 0,
    },
    .Especular = 15,
    .Refractive_index = 0,
};

// ============================================================================
// OBJETOS DE LA ESCENA
// ============================================================================

pub const objects = [_]Forma{
    .{ .Plane = .{
        .point = .{ .x = 0, .y = -5, .z = 0 },
        .normal = .{ .x = 0, .y = 1, .z = 0 },
        .material = suelo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 10, .y = 0, .z = -40 },
        .radius = 5,
        .material = espejo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 12.5, .y = 0, .z = -60 },
        .radius = 5,
        .material = rojo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 0, .y = 0, .z = 0 },
        .radius = 5,
        .material = marmol,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 22, .y = 0, .z = -45 },
        .radius = 5,
        .material = espejo,
    } },
    .{ .Sphere = .{
        .center = .{ .x = -25, .y = 0, .z = -40 },
        .radius = 5,
        .material = vidrio,
    } },
    .{ .Sphere = .{
        .center = .{ .x = -37, .y = 0, .z = -40 },
        .radius = 5,
        .material = diamante,
    } },
};

// Alias por compatibilidad
pub const spheres = objects;

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
