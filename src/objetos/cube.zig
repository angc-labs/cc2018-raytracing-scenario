const std = @import("std");
const rl = @import("raylib");
const Intersect = @import("../raytracer.zig").Intersect;
const Material = @import("../materiales/material.zig").Material;

pub const Cube = struct {
    center: rl.Vector3,
    size: f32,
    material: Material,

    pub fn intersect(self: Cube, origin: rl.Vector3, direction: rl.Vector3) ?Intersect {
        const half = self.size * 0.5;
        const min = rl.Vector3{ .x = self.center.x - half, .y = self.center.y - half, .z = self.center.z - half };
        const max = rl.Vector3{ .x = self.center.x + half, .y = self.center.y + half, .z = self.center.z + half };

        var t_min: f32 = -std.math.floatMax(f32);
        var t_max: f32 = std.math.floatMax(f32);
        var normal_min = rl.Vector3.zero();
        var normal_max = rl.Vector3.zero();

        const origins = [3]f32{ origin.x, origin.y, origin.z };
        const dirs = [3]f32{ direction.x, direction.y, direction.z };
        const mins = [3]f32{ min.x, min.y, min.z };
        const maxs = [3]f32{ max.x, max.y, max.z };
        const normals = [3]rl.Vector3{
            .{ .x = 1, .y = 0, .z = 0 },
            .{ .x = 0, .y = 1, .z = 0 },
            .{ .x = 0, .y = 0, .z = 1 },
        };

        inline for (0..3) |i| {
            if (@abs(dirs[i]) > 1e-6) {
                var t1 = (mins[i] - origins[i]) / dirs[i];
                var t2 = (maxs[i] - origins[i]) / dirs[i];
                var sign1: f32 = -1.0;
                var sign2: f32 = 1.0;
                if (t1 > t2) {
                    std.mem.swap(f32, &t1, &t2);
                    sign1 = 1.0;
                    sign2 = -1.0;
                }
                if (t1 > t_min) {
                    t_min = t1;
                    normal_min = normals[i].scale(sign1);
                }
                if (t2 < t_max) {
                    t_max = t2;
                    normal_max = normals[i].scale(sign2);
                }
            } else if (origins[i] < mins[i] or origins[i] > maxs[i]) {
                return null;
            }
        }

        if (t_min > t_max) return null;

        const hit_outside = t_min > 0.001;
        const t = if (hit_outside) t_min else t_max;
        if (t <= 0.001) return null;

        const point = origin.add(direction.scale(t));
        const norm = if (hit_outside) normal_min else normal_max;

        return .{
            .Material = self.material,
            .Distancia = t,
            .Normal = norm,
            .Punto = point,
        };
    }
};
