const rl = @import("raylib");
const Material = @import("material.zig").Material;
const htmlColor = @import("../cute_colors.zig").htmlColor;
const V3FromColor = @import("../raytracer.zig").V3FromColor;

// ============================================================================
// MATERIALES PREDEFINIDOS
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
