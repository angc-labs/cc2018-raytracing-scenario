// Referencia y cita: https://www.instructables.com/Raytracing-With-Landscapes/
const std = @import("std");
const builtin = @import("builtin");

const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Forma = @import("objetos/forma.zig").Forma;
const Camera = @import("camera.zig").Camera;
const Light = @import("raytracer.zig").Light;
const Intersect = @import("raytracer.zig").Intersect;
const Material = @import("materiales/material.zig").Material;
const V3ToColor = @import("raytracer.zig").V3ToColor;
const config = @import("config.zig");

const Clock = std.Io.Clock.real;

const width = 1300;
const height = 900;

const block_sz = 100;

// Color celeste de fondo
const celeste = rl.Vector3{ .x = 0.6, .y = 0.8, .z = 1.0 };

pub fn main() !void {
    var alloc = switch (builtin.mode) {
        .Debug, .ReleaseSafe => std.heap.DebugAllocator(.{}).init,
        .ReleaseFast, .ReleaseSmall => std.heap.smp_allocator,
    };
    const gpa: std.mem.Allocator = switch (builtin.mode) {
        .Debug, .ReleaseSafe => alloc.allocator(),
        .ReleaseFast, .ReleaseSmall => std.heap.smp_allocator,
    };
    defer switch (builtin.mode) {
        .Debug, .ReleaseSafe => _ = alloc.deinit(),
        .ReleaseFast, .ReleaseSmall => {},
    };

    var threaded: std.Io.Threaded = .init(gpa, .{});
    const io = threaded.io();
    var framebuffer = Framebuffer.init(width, height, V3ToColor(celeste), .white);

    rl.initWindow(width, height, "Raytracer!!!");
    rl.setTraceLogLevel(.warning);
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var last_frame_time = Clock.now(io);
    var delta: i64 = 1;



    // ============================
    // CONFIG
    // ============================
    var cameraDistance: f32 = 100.0;
    const cameraZoomSpeed: f32 = 60.0;
    var camera: Camera = .init(.{
        .x = 0,
        .y = 0,
        .z = cameraDistance,
    }, .zero());

    const cameraTurnSpeed: f32 = std.math.pi / 2.0;
    var camera_x_angle: f32 = 243.6 * std.math.pi / 180.0;
    var camera_y_angle: f32 = 0;

    const camera_y_angle_max = std.math.pi / 4.0;
    const camera_y_angle_min = -camera_y_angle_max;

    var screenshot_taken: bool = false;

    while (!rl.windowShouldClose()) {
        defer {
            const now = Clock.now(io);
            delta = last_frame_time.durationTo(now).toMicroseconds();
            last_frame_time = now;
        }
        framebuffer.clear();

        const dt: f32 = @as(f32, @floatFromInt(delta)) / 1_000_000;

        // controles de rotacion
        if (rl.isKeyDown(.a)) {
            camera_x_angle += cameraTurnSpeed * dt;
        }
        if (rl.isKeyDown(.d)) {
            camera_x_angle -= cameraTurnSpeed * dt;
        }
        if (rl.isKeyDown(.w)) {
            camera_y_angle += cameraTurnSpeed * dt;
            camera_y_angle = @max(camera_y_angle_min, @min(camera_y_angle_max, camera_y_angle));
        }
        if (rl.isKeyDown(.s)) {
            camera_y_angle -= cameraTurnSpeed * dt;
            camera_y_angle = @max(camera_y_angle_min, @min(camera_y_angle_max, camera_y_angle));
        }

        // controles de zoom (acercar / alejar)
        if (rl.isKeyDown(.e) or rl.isKeyDown(.up)) {
            cameraDistance -= cameraZoomSpeed * dt;
        }
        if (rl.isKeyDown(.q) or rl.isKeyDown(.down)) {
            cameraDistance += cameraZoomSpeed * dt;
        }

        const mouse_wheel = rl.getMouseWheelMove();
        if (mouse_wheel != 0) {
            cameraDistance -= mouse_wheel * 5.0;
        }
        cameraDistance = @max(10.0, @min(300.0, cameraDistance));

        camera.Postition.x = @cos(camera_x_angle) * cameraDistance;
        camera.Postition.y = @sin(camera_y_angle) * cameraDistance;
        camera.Postition.z = @sin(camera_x_angle) * cameraDistance;

        camera.lookAt(.zero());

        try render(&framebuffer, &config.objects, &config.lights, camera);

        if (!screenshot_taken or rl.isKeyPressed(.p) or rl.isKeyPressed(.f12)) {
            try framebuffer.render_to_file("resultado.png");
            screenshot_taken = true;
        }

        try framebuffer.swap_buffers();
    }
}

fn render(target: *Framebuffer, objects: []const Forma, lights: []const Light, camera: Camera) !void {
    const width_f32: f32 = @floatFromInt(target.width);
    const height_f32: f32 = @floatFromInt(target.height);

    const aspect_ratio = width_f32 / height_f32;
    const FOV = std.math.pi / 3.0;
    const perspective_scale = @tan(FOV * 0.5);

    for (0..height) |screen_y| {
        for (0..width) |screen_x| {
            const x_f32: f32 = @floatFromInt(screen_x);
            const y_f32: f32 = @floatFromInt(screen_y);

            const x_minus1_to_1 = (x_f32 * 2) / width_f32 - 1;
            const y_minus1_to_1 = 1 - (y_f32 * 2) / height_f32;

            const x_direction = x_minus1_to_1 * aspect_ratio * perspective_scale;
            const y_direction = y_minus1_to_1 * perspective_scale;

            const direction_from_camera = (rl.Vector3{
                .x = x_direction,
                .y = y_direction,
                .z = 1,
            }).normalize();

            const direction = rl.Vector3{
                .x = direction_from_camera.x * camera.Right.x + direction_from_camera.y * camera.Up.x + direction_from_camera.z * camera.Forward.x,
                .y = direction_from_camera.x * camera.Right.y + direction_from_camera.y * camera.Up.y + direction_from_camera.z * camera.Forward.y,
                .z = direction_from_camera.x * camera.Right.z + direction_from_camera.y * camera.Up.z + direction_from_camera.z * camera.Forward.z,
            };

            const col = cast_ray(camera.Postition, direction, objects, lights, 5);
            target.set_current_color(V3ToColor(col));
            try target.set_pixel(@intCast(screen_x), @intCast(screen_y));
        }
    }
}

fn reflect(incident: rl.Vector3, normal: rl.Vector3) rl.Vector3 {
    return incident.subtract(normal.scale(2.0 * incident.dotProduct(normal))).normalize();
}

fn refract(incident: rl.Vector3, normal: rl.Vector3, refractive_index: f32) ?rl.Vector3 {
    var cosi = incident.dotProduct(normal);

    var etai: f32 = 1;
    var etat = refractive_index;
    var n = normal;

    if (cosi > 0) {
        std.mem.swap(f32, &etai, &etat);
        n = n.scale(-1);
    } else {
        cosi = -cosi;
    }

    const eta = etai / etat;
    const k = 1 - eta * eta * (1 - cosi * cosi);

    if (k < 0) {
        return null;
    } else {
        return (incident.scale(eta).add(n.scale(eta * cosi - @sqrt(k)))).normalize();
    }
}

fn cast_ray(origin: rl.Vector3, direction: rl.Vector3, objects: []const Forma, lights: []const Light, max_recursion: usize) rl.Vector3 {
    var closest_hit: ?Intersect = null;
    var z_buffer: f32 = std.math.floatMax(f32);
    for (objects) |object| {
        const hit = object.intersect(
            origin,
            direction,
        ) orelse continue;

        if (hit.Distancia < z_buffer) {
            z_buffer = hit.Distancia;

            closest_hit = hit;
        }
    }

    if (closest_hit) |hit| {
        const mat = hit.Material;
        var color: rl.Vector3 = .zero();

        // emision de luz propia
        if (mat.Propiedades.Emision > 0) {
            const emit_color = mat.Color_Emision orelse mat.Color;
            color = color.add(emit_color.scale(mat.Propiedades.Emision));
        }

        // evita sombras negras y da brillo
        if (mat.Propiedades.Translucidez > 0) {
            color = color.add(mat.Color.scale(0.12 * mat.Propiedades.Translucidez));
        }

        // desde el punto a la camara
        const view_dir = direction.scale(-1).normalize();

        const bias: f32 = 0.001;
        const normal_offset = if (direction.dotProduct(hit.Normal) < 0)
            hit.Normal.scale(bias)
        else
            hit.Normal.scale(-bias);

        if (mat.Propiedades.Reflectividad > 0) {
            if (max_recursion > 0) {
                const reflect_direction = reflect(direction, hit.Normal);
                const reflect_orig = hit.Punto.add(normal_offset);
                const reflect_color = cast_ray(reflect_orig, reflect_direction, objects, lights, max_recursion - 1);
                color = color.add(reflect_color.scale(mat.Propiedades.Reflectividad));
            } else {
                color = color.add(celeste.scale(mat.Propiedades.Reflectividad));
            }
        }

        if (mat.Propiedades.Transparencia > 0) {
            if (max_recursion > 0) {
                if (refract(direction, hit.Normal, mat.Refractive_index)) |refract_direction| {
                    const refract_orig = hit.Punto.subtract(normal_offset);
                    const refract_color = cast_ray(refract_orig, refract_direction, objects, lights, max_recursion - 1);
                    // para materiales traslucidos, la luz que pasa se convierte con al color del material
                    const pass_color = if (mat.Propiedades.Translucidez > 0)
                        rl.Vector3{
                            .x = refract_color.x * mat.Color.x,
                            .y = refract_color.y * mat.Color.y,
                            .z = refract_color.z * mat.Color.z,
                        }
                    else
                        refract_color;
                    color = color.add(pass_color.scale(mat.Propiedades.Transparencia));
                } else {
                    const tir_direction = reflect(direction, hit.Normal);
                    const tir_orig = hit.Punto.add(normal_offset);
                    const tir_color = cast_ray(tir_orig, tir_direction, objects, lights, max_recursion - 1);
                    color = color.add(tir_color.scale(mat.Propiedades.Transparencia));
                }
            } else {
                color = color.add(celeste.scale(mat.Propiedades.Transparencia));
            }
        }

        for (lights) |light| {
            const info = light.get_dir_and_dist(hit.Punto) orelse continue;
            const light_dir = info.dir;

            const n_dot_l = hit.Normal.dotProduct(light_dir);

            // 1. iluminacion directa (frente a la luz)
            if (n_dot_l > 0) {
                const shadow_orig = hit.Punto.add(normal_offset);
                if (!obscured(shadow_orig, light, objects)) {
                    // iluminacion difusa
                    const diffuse_intensity = n_dot_l * light.Intensity;
                    const diffuse = mat.Color.scale(diffuse_intensity);

                    // iluminacion especular
                    const reflection_dir = reflect(light_dir.scale(-1), hit.Normal);
                    const r_dot_v = @max(0.0, reflection_dir.dotProduct(view_dir));
                    const specular_intensity = std.math.pow(f32, r_dot_v, mat.Especular) * light.Intensity;
                    const specular = light.Color.scale(specular_intensity);

                    color = color.add(diffuse.scale(mat.Propiedades.Albedo));
                    color = color.add(specular.scale(mat.Propiedades.Especular));
                }
            }

            // 2. iluminacion traslucida (luz que atraviesa el objeto desde atras, como el alabastro)
            if (mat.Propiedades.Translucidez > 0 and n_dot_l < 0) {
                // en direccion hacia la luz desde la camara
                const forward_scatter = @max(0.0, direction.dotProduct(light_dir));
                // -n_dot_l representa la intensidad de la luz que entra por la cara trasera
                const trans_intensity = (-n_dot_l * 0.4 + forward_scatter * 0.6) * light.Intensity * mat.Propiedades.Translucidez;
                const trans_light = rl.Vector3{
                    .x = mat.Color.x * light.Color.x * trans_intensity,
                    .y = mat.Color.y * light.Color.y * trans_intensity,
                    .z = mat.Color.z * light.Color.z * trans_intensity,
                };
                color = color.add(trans_light);
            }
        }

        return color;
    } else return celeste;
}

fn obscured(origin: rl.Vector3, light: Light, objects: []const Forma) bool {
    const info = light.get_dir_and_dist(origin) orelse return false;

    for (objects) |object| {
        const hit = object.intersect(origin, info.dir) orelse continue;
        // los objetos que emiten luz no bloquean la luz
        if (hit.Material.Propiedades.Emision > 0) continue;
        if (hit.Distancia > 0 and hit.Distancia < info.dist) {
            return true;
        }
    }

    return false;
}
