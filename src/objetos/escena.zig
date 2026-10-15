const Forma = @import("forma.zig").Forma;
const materiales = @import("../materiales/mod.zig");

// ============================================================================
// objetos de la escena: pista de bolos (bowling alley)
// ============================================================================

pub const objects = [_]Forma{
    // suelo base del salon de bolos
    .{ .Plane = .{
        .point = .{ .x = 0, .y = -5, .z = 0 },
        .normal = .{ .x = 0, .y = 1, .z = 0 },
        .material = materiales.suelo,
    } },

    // pista de madera pulida y barnizada
    .{ .Cube = .{
        .center = .{ .x = 0, .y = -4.5, .z = -12.0 },
        .dimensions = .{ .x = 11.5, .y = 1.0, .z = 46.0 },
        .material = materiales.pista_madera,
    } },

    // canaleta izquierda
    .{ .Cube = .{
        .center = .{ .x = -6.5, .y = -4.75, .z = -12.0 },
        .dimensions = .{ .x = 1.5, .y = 0.5, .z = 46.0 },
        .material = materiales.canaleta,
    } },

    // canaleta derecha
    .{ .Cube = .{
        .center = .{ .x = 6.5, .y = -4.75, .z = -12.0 },
        .dimensions = .{ .x = 1.5, .y = 0.5, .z = 46.0 },
        .material = materiales.canaleta,
    } },

    // pista adyacente izquierda del salon de bolos
    .{ .Cube = .{
        .center = .{ .x = -15.0, .y = -4.5, .z = -12.0 },
        .dimensions = .{ .x = 11.5, .y = 1.0, .z = 46.0 },
        .material = materiales.pista_madera,
    } },

    // pista adyacente derecha del salon de bolos
    .{ .Cube = .{
        .center = .{ .x = 15.0, .y = -4.5, .z = -12.0 },
        .dimensions = .{ .x = 11.5, .y = 1.0, .z = 46.0 },
        .material = materiales.pista_madera,
    } },

    // maquina de bolos al fondo de la pista principal (pinsetter)
    .{ .Cube = .{
        .center = .{ .x = 0, .y = 1.8, .z = -33.5 },
        .dimensions = .{ .x = 15.0, .y = 8.5, .z = 3.0 },
        .material = materiales.canaleta,
    } },

    // pared lateral izquierda amplia del salon
    .{ .Cube = .{
        .center = .{ .x = -32.0, .y = 3.5, .z = -18.0 },
        .dimensions = .{ .x = 1.5, .y = 18.0, .z = 66.0 },
        .material = materiales.pared_bolera,
    } },

    // pared lateral derecha amplia del salon
    .{ .Cube = .{
        .center = .{ .x = 32.0, .y = 3.5, .z = -18.0 },
        .dimensions = .{ .x = 1.5, .y = 18.0, .z = 66.0 },
        .material = materiales.pared_bolera,
    } },

    // muro posterior del salon de bolos
    .{ .Cube = .{
        .center = .{ .x = 0, .y = 3.5, .z = -48.0 },
        .dimensions = .{ .x = 66.0, .y = 18.0, .z = 1.5 },
        .material = materiales.canaleta,
    } },

    // muro frontal detras del area del jugador
    .{ .Cube = .{
        .center = .{ .x = 0, .y = 3.5, .z = 16.0 },
        .dimensions = .{ .x = 66.0, .y = 18.0, .z = 1.5 },
        .material = materiales.canaleta,
    } },

    // techo interior del salon de bolos
    .{ .Cube = .{
        .center = .{ .x = 0, .y = 12.0, .z = -18.0 },
        .dimensions = .{ .x = 66.0, .y = 1.5, .z = 66.0 },
        .material = materiales.pared_bolera,
    } },

    // letrero de neon luminoso de la bolera sobre los pinos
    .{ .Cube = .{
        .center = .{ .x = 0, .y = 6.2, .z = -29.0 },
        .dimensions = .{ .x = 13.0, .y = 1.0, .z = 1.0 },
        .material = materiales.neon_bolera,
    } },

    // bola de bolos rodando por la pista hacia los pinos
    .{ .Sphere = .{
        .center = .{ .x = -1.2, .y = -2.3, .z = -3.0 },
        .radius = 1.7,
        .material = materiales.bola_bolos,
    } },

    // bola de bolos de repuesto en el lateral derecho
    .{ .Sphere = .{
        .center = .{ .x = 8.5, .y = -2.6, .z = 6.0 },
        .radius = 1.4,
        .material = materiales.espejo,
    } },

    // pino 1 (pino frontal rey): pino especial de alabastro traslucido que brilla con la luz
    .{ .Sphere = .{
        .center = .{ .x = 0, .y = -2.9, .z = -22.0 },
        .radius = 1.1,
        .material = materiales.alabastro,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 0, .y = -1.3, .z = -22.0 },
        .radius = 0.65,
        .material = materiales.alabastro,
    } },

    // pino 2 (fila 2 izquierda): pino de esmeralda reflectiva que tine los reflejos de verde
    .{ .Sphere = .{
        .center = .{ .x = -1.8, .y = -2.9, .z = -25.0 },
        .radius = 1.1,
        .material = materiales.esmeralda,
    } },
    .{ .Sphere = .{
        .center = .{ .x = -1.8, .y = -1.3, .z = -25.0 },
        .radius = 0.65,
        .material = materiales.esmeralda,
    } },

    // pino 3 (fila 2 derecha): pino de zafiro de cristal que refracta la luz
    .{ .Sphere = .{
        .center = .{ .x = 1.8, .y = -2.9, .z = -25.0 },
        .radius = 1.1,
        .material = materiales.zafiro,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 1.8, .y = -1.3, .z = -25.0 },
        .radius = 0.65,
        .material = materiales.zafiro,
    } },

    // pino 4 (fila 3 izquierda): pino tradicional esmaltado blanco
    .{ .Sphere = .{
        .center = .{ .x = -3.6, .y = -2.9, .z = -28.0 },
        .radius = 1.1,
        .material = materiales.pino_blanco,
    } },
    .{ .Sphere = .{
        .center = .{ .x = -3.6, .y = -1.3, .z = -28.0 },
        .radius = 0.65,
        .material = materiales.pino_blanco,
    } },

    // pino 5 (fila 3 centro): pino de rubi rojo reflectivo
    .{ .Sphere = .{
        .center = .{ .x = 0, .y = -2.9, .z = -28.0 },
        .radius = 1.1,
        .material = materiales.rubi,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 0, .y = -1.3, .z = -28.0 },
        .radius = 0.65,
        .material = materiales.rubi,
    } },

    // pino 6 (fila 3 derecha): pino tradicional esmaltado blanco
    .{ .Sphere = .{
        .center = .{ .x = 3.6, .y = -2.9, .z = -28.0 },
        .radius = 1.1,
        .material = materiales.pino_blanco,
    } },
    .{ .Sphere = .{
        .center = .{ .x = 3.6, .y = -1.3, .z = -28.0 },
        .radius = 0.65,
        .material = materiales.pino_blanco,
    } },
};

// alias por compatibilidad
pub const spheres = objects;
