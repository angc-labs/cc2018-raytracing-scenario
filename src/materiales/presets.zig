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

// lampara o sol: material emisivo
pub const lampara = Material{
    .Color = .{ .x = 1.0, .y = 0.95, .z = 0.8 },
    .Especular = 10,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.1,
        .Especular = 0,
        .Reflectividad = 0,
        .Transparencia = 0,
        .Emision = 2.0,
    },
    // color de la luz emitida (se puede personalizar con cualquier vector)
    .Color_Emision = .{ .x = 1.0, .y = 0.9, .z = 0.4 },
};

// crea un material emisivo con el color de luz y la intensidad deseada
pub fn crear_lampara(color_luz: rl.Vector3, intensidad: f32) Material {
    return .{
        .Color = color_luz,
        .Especular = 10,
        .Refractive_index = 0,
        .Propiedades = .{
            .Albedo = 0.1,
            .Especular = 0,
            .Reflectividad = 0,
            .Transparencia = 0,
            .Emision = intensidad,
        },
        .Color_Emision = color_luz,
    };
}

// esmeralda de kokiri: material reflectivo y refractivo que tine los reflejos de verde
pub const esmeralda = Material{
    .Color = .{ .x = 0.1, .y = 0.95, .z = 0.3 },
    .Especular = 120,
    .Refractive_index = 1.57,
    .Propiedades = .{
        .Albedo = 0.15,
        .Especular = 0.7,
        .Reflectividad = 0.5,
        .Transparencia = 0.4,
        .Translucidez = 0.2,
    },
};

// rubi de los goron: gema roja reflectiva y refractiva
pub const rubi = Material{
    .Color = .{ .x = 0.95, .y = 0.1, .z = 0.2 },
    .Especular = 120,
    .Refractive_index = 1.77,
    .Propiedades = .{
        .Albedo = 0.15,
        .Especular = 0.7,
        .Reflectividad = 0.5,
        .Transparencia = 0.4,
        .Translucidez = 0.2,
    },
};

// zafiro de los zora: gema azul brillante
pub const zafiro = Material{
    .Color = .{ .x = 0.15, .y = 0.45, .z = 0.95 },
    .Especular = 120,
    .Refractive_index = 1.77,
    .Propiedades = .{
        .Albedo = 0.15,
        .Especular = 0.7,
        .Reflectividad = 0.5,
        .Transparencia = 0.4,
        .Translucidez = 0.2,
    },
};

// hada navi: esfera que brilla con luz celeste brillante propia
pub const navi = Material{
    .Color = .{ .x = 0.7, .y = 0.9, .z = 1.0 },
    .Especular = 10,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.1,
        .Especular = 0,
        .Reflectividad = 0,
        .Transparencia = 0,
        .Emision = 3.5,
    },
    .Color_Emision = .{ .x = 0.5, .y = 0.85, .z = 1.0 },
};

// piedra oscura para la base del altar del templo
pub const piedra_altar = Material{
    .Color = .{ .x = 0.18, .y = 0.20, .z = 0.20 },
    .Especular = 30,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.7,
        .Especular = 0.2,
        .Reflectividad = 0.1,
        .Transparencia = 0,
    },
};

// oro para los soportes de las piedras espirituales
pub const oro = Material{
    .Color = .{ .x = 1.0, .y = 0.84, .z = 0.0 },
    .Especular = 80,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.3,
        .Especular = 0.8,
        .Reflectividad = 0.6,
        .Transparencia = 0,
    },
};

// madera pulida y barnizada de la pista de bolos con reflejo suave
pub const pista_madera = Material{
    .Color = .{ .x = 0.90, .y = 0.70, .z = 0.45 },
    .Especular = 80,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.65,
        .Especular = 0.5,
        .Reflectividad = 0.28,
        .Transparencia = 0,
    },
};

// canaleta oscura mate a los lados de la pista de bolos
pub const canaleta = Material{
    .Color = .{ .x = 0.15, .y = 0.15, .z = 0.18 },
    .Especular = 20,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.7,
        .Especular = 0.2,
        .Reflectividad = 0.05,
        .Transparencia = 0,
    },
};

// bola de bolos de resina roja pulida y brillante
pub const bola_bolos = Material{
    .Color = .{ .x = 0.85, .y = 0.08, .z = 0.15 },
    .Especular = 140,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.35,
        .Especular = 0.9,
        .Reflectividad = 0.45,
        .Transparencia = 0,
    },
};

// pino de bolos tradicional con esmalte blanco brillante
pub const pino_blanco = Material{
    .Color = .{ .x = 0.95, .y = 0.95, .z = 0.95 },
    .Especular = 100,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.75,
        .Especular = 0.6,
        .Reflectividad = 0.2,
        .Transparencia = 0,
    },
};

// lampara de neon brillante de la bolera que emite luz propia
pub const neon_bolera = Material{
    .Color = .{ .x = 1.0, .y = 0.85, .z = 0.35 },
    .Especular = 10,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.1,
        .Especular = 0,
        .Reflectividad = 0,
        .Transparencia = 0,
        .Emision = 3.5,
    },
    .Color_Emision = .{ .x = 1.0, .y = 0.85, .z = 0.35 },
};

// pared de la bolera con acabado mate suave
pub const pared_bolera = Material{
    .Color = .{ .x = 0.20, .y = 0.22, .z = 0.26 },
    .Especular = 10,
    .Refractive_index = 0,
    .Propiedades = .{
        .Albedo = 0.8,
        .Especular = 0.1,
        .Reflectividad = 0.05,
        .Transparencia = 0,
    },
};
