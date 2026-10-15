const rl = @import("raylib");
pub const Material = @import("materiales/material.zig").Material;

pub fn V3FromColor(src: rl.Color) rl.Vector3 {
    const x: f32 = @floatFromInt(src.r);
    const y: f32 = @floatFromInt(src.g);
    const z: f32 = @floatFromInt(src.b);
    return .{ .x = x / 255, .y = y / 255, .z = z / 255 };
}

pub fn V3ToColor(color: rl.Vector3) rl.Color {
    const r: u8 = @intFromFloat(@max(0, @min(255, color.x * 255)));
    const g: u8 = @intFromFloat(@max(0, @min(255, color.y * 255)));
    const b: u8 = @intFromFloat(@max(0, @min(255, color.z * 255)));
    return .{ .r = r, .g = g, .b = b, .a = 0xff };
}

const std = @import("std");

pub const LightType = enum {
    punto,
    direccional,
};

pub const Light = struct {
    Color: rl.Vector3,
    Position: rl.Vector3 = .zero(),
    Direction: rl.Vector3 = .{ .x = 0, .y = -1, .z = 0 },
    Intensity: f32 = 1.0,
    tipo: LightType = .punto,

    // calcula direccion hacia la fuente de luz y distancia maxima
    pub fn get_dir_and_dist(self: Light, from_point: rl.Vector3) ?struct { dir: rl.Vector3, dist: f32 } {
        switch (self.tipo) {
            .punto => {
                const vec = self.Position.subtract(from_point);
                const dist = vec.length();
                if (dist == 0) return null;
                return .{ .dir = vec.scale(1.0 / dist), .dist = dist };
            },
            .direccional => {
                // los rayos de luz direccional viajan paralelos en una misma direccion
                const len = self.Direction.length();
                if (len == 0) return null;
                return .{ .dir = self.Direction.scale(-1.0 / len), .dist = std.math.inf(f32) };
            },
        }
    }

    // funcion para crear luz puntual tradicional
    pub fn punto(pos: rl.Vector3, col: rl.Vector3, intensidad: f32) Light {
        return .{
            .Position = pos,
            .Color = col,
            .Intensity = intensidad,
            .tipo = .punto,
        };
    }

    // funcion para crear luz direccional como la del sol
    pub fn direccional(dir: rl.Vector3, col: rl.Vector3, intensidad: f32) Light {
        return .{
            .Direction = dir,
            .Color = col,
            .Intensity = intensidad,
            .tipo = .direccional,
        };
    }
};

pub const Intersect = struct {
    Material: Material,
    Distancia: f32,
    Normal: rl.Vector3,
    Punto: rl.Vector3,
};
