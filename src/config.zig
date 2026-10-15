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
pub const esmeralda = materiales.esmeralda;
pub const rubi = materiales.rubi;
pub const zafiro = materiales.zafiro;
pub const navi = materiales.navi;
pub const piedra_altar = materiales.piedra_altar;
pub const oro = materiales.oro;
pub const pista_madera = materiales.pista_madera;
pub const canaleta = materiales.canaleta;
pub const bola_bolos = materiales.bola_bolos;
pub const pino_blanco = materiales.pino_blanco;
pub const neon_bolera = materiales.neon_bolera;
pub const pared_bolera = materiales.pared_bolera;

// ============================================================================
// objetos de la escena (re-exportados desde src/objetos)
// ============================================================================

pub const objects = objetos.objects;
pub const spheres = objetos.spheres;

// ============================================================================
// luces
// ============================================================================

pub const lights = [_]Light{
    // luz direccional: focos longitudinales del techo de la bolera
    Light.direccional(.{ .x = 0.1, .y = -1.0, .z = -0.5 }, .{ .x = 1.0, .y = 0.96, .z = 0.88 }, 0.9),
    // luz puntual brillante del letrero neon sobre los pinos
    Light.punto(.{ .x = 0, .y = 5.5, .z = -28 }, .{ .x = 1.0, .y = 0.9, .z = 0.5 }, 2.0),
    // luz trasera dentro del pinsetter para iluminar el pino traslucido de alabastro
    Light.punto(.{ .x = 0, .y = 0, .z = -34 }, .{ .x = 1.0, .y = 0.95, .z = 0.9 }, 1.3),
};
