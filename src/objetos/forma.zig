// Referencia y cita: https://www.instructables.com/Raytracing-With-Landscapes/
const Sphere = @import("sphere.zig").Sphere;
const Plane = @import("plane.zig").Plane;
const Cube = @import("cube.zig").Cube;
const Intersect = @import("../raytracer.zig").Intersect;
const rl = @import("raylib");

const tipo = enum {
    Sphere,
    Plane,
    Cube,
};

pub const Forma = union(tipo) {
    Sphere: Sphere,
    Plane: Plane,
    Cube: Cube,

    pub fn intersect(self: Forma, origin: rl.Vector3, direction: rl.Vector3) ?Intersect {
        return switch (self) {
            .Sphere => |a| a.intersect(origin, direction),
            .Plane => |p| p.intersect(origin, direction),
            .Cube => |c| c.intersect(origin, direction),
        };
    }
};
