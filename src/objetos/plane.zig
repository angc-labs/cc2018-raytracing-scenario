// Referencia: https://www.instructables.com/Raytracing-With-Landscapes/
const rl = @import("raylib");
const Intersect = @import("../raytracer.zig").Intersect;
const Material = @import("../materiales/material.zig").Material;

pub const Plane = struct {
    point: rl.Vector3,
    normal: rl.Vector3,
    material: Material,

    pub fn intersect(self: Plane, origin: rl.Vector3, direction: rl.Vector3) ?Intersect {
        const denom = self.normal.dotProduct(direction);
        if (@abs(denom) > 1e-6) {
            const p0_to_origin = self.point.subtract(origin);
            const t = p0_to_origin.dotProduct(self.normal) / denom;
            if (t > 0.001) {
                const hit_point = origin.add(direction.scale(t));
                const hit_norm = if (denom < 0) self.normal else self.normal.scale(-1.0);
                return .{
                    .Material = self.material,
                    .Distancia = t,
                    .Normal = hit_norm,
                    .Punto = hit_point,
                };
            }
        }
        return null;
    }
};
