const rl = @import("raylib");

pub const PropiedadesMaterial = struct {
    Albedo: f32,
    Especular: f32,
    Reflectividad: f32,
    Transparencia: f32,
    // 0 = opaco, mayor a 0 = traslucido (la luz pasa y se dispersa)
    Translucidez: f32 = 0,
};

pub const Material = struct {
    // xyz como rgb, pero reducimos conversiones primero haciendo mate en f32 y luego convertimos de regreso a u8
    Color: rl.Vector3,
    Especular: f32,
    Refractive_index: f32,
    Propiedades: PropiedadesMaterial,
};
