// Referencia y cita: https://www.instructables.com/Raytracing-With-Landscapes/
const Sphere = @import("sphere.zig").Sphere;
const Plane = @import("plane.zig").Plane;
const Intersect = @import("raytracer.zig").Intersect;
const rl = @import("raylib");

const tipo = enum {
    Sphere,
    Plane,
};

pub const Forma = union(tipo) {
    Sphere: Sphere,
    Plane: Plane,

    pub fn intersect(self: Forma, origin: rl.Vector3, direction: rl.Vector3) ?Intersect {
        return switch (self) {
            .Sphere => |a| a.intersect(origin, direction),
            .Plane => |p| p.intersect(origin, direction),
        };
    }
};
