const rl = @import("raylib");
const Material = @import("material.zig").Material;

// ============================================================================
// MATERIALES PREDEFINIDOS
// ============================================================================

pub const espejo = Material{
    .Color = .{ .x = 1.0, .y = 1.0, .z = 1.0 },
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
    .Color = .{ .x = 0.67, .y = 0.67, .z = 0.67 },
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
    .Color = .{ .x = 0.67, .y = 0.67, .z = 0.67 },
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
    .Color = .{ .x = 0.4, .y = 0.4, .z = 0.3 },
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
    .Color = .{ .x = 0.29, .y = 0.33, .z = 0.41 },
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
    .Color = .{ .x = 1.0, .y = 0.2, .z = 0.2 },
    .Propiedades = .{
        .Albedo = 0.85,
        .Especular = 1.0,
        .Reflectividad = 0,
        .Transparencia = 0,
    },
    .Especular = 15,
    .Refractive_index = 0,
};

// alabastro
pub const alabastro = Material{
    .Color = .{ .x = 0.92, .y = 0.88, .z = 0.78 },
    .Propiedades = .{
        .Albedo = 0.1,
        .Especular = 0.8,
        .Reflectividad = 0.15,
        .Transparencia = 0.7,
        .Translucidez = 0.8,
    },
    .Especular = 50,
    .Refractive_index = 1.25,
};
