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
    // posicion inicial y distancia de camara hacia la pista de bolos
    var cameraDistance: f32 = 22.0;
    const cameraZoomSpeed: f32 = 30.0;
    var camera: Camera = .init(.{
        .x = 0,
        .y = 2.5,
        .z = 4.0,
    }, .{ .x = 0, .y = -2.0, .z = -18 });

    const cameraTurnSpeed: f32 = std.math.pi / 2.0;
    var camera_x_angle: f32 = std.math.pi * 0.5;
    var camera_y_angle: f32 = 0.10;

    // limites de inclinacion vertical dentro del salon
    const camera_y_angle_max: f32 = 0.35;
    const camera_y_angle_min: f32 = -0.05;

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
        // limita el zoom para mantenerse siempre dentro de las paredes del salon
        cameraDistance = @max(6.0, @min(24.0, cameraDistance));

        // orbita de camara centrada en la pista de bolos
        const target_pista = rl.Vector3{ .x = 0, .y = -2.0, .z = -18.0 };
        camera.Postition.x = target_pista.x + @cos(camera_x_angle) * cameraDistance;
        camera.Postition.y = target_pista.y + @sin(camera_y_angle) * cameraDistance + 2.5;
        camera.Postition.z = target_pista.z + @sin(camera_x_angle) * cameraDistance;

        camera.lookAt(target_pista);

        try render(&framebuffer, &config.objects, &config.lights, camera);

        if (!screenshot_taken or rl.isKeyPressed(.p) or rl.isKeyPressed(.f12)) {
            try framebuffer.render_to_file("resultado.png");
            screenshot_taken = true;
        }

        try framebuffer.swap_buffers();
    }
}

// referencia: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-ray-tracing/ray-tracing-practical-example.html
// referencia hilos: https://dev.to/11110110011/parallel-programming-in-zig-threads-shared-memory-and-synchronization-2k21
const RenderContext = struct {
    target: *Framebuffer,
    objects: []const Forma,
    lights: []const Light,
    camera: Camera,
    thread_id: usize,
    total_threads: usize,
    width_f32: f32,
    height_f32: f32,
    aspect_ratio: f32,
    perspective_scale: f32,
};

// funcion que ejecuta cada hilo sobre filas intercaladas para balancear la carga de trabajo
fn render_rows(ctx: RenderContext) void {
    var screen_y: usize = ctx.thread_id;
    while (screen_y < height) : (screen_y += ctx.total_threads) {
        for (0..width) |screen_x| {
            const x_f32: f32 = @floatFromInt(screen_x);
            const y_f32: f32 = @floatFromInt(screen_y);

            const x_minus1_to_1 = (x_f32 * 2) / ctx.width_f32 - 1;
            const y_minus1_to_1 = 1 - (y_f32 * 2) / ctx.height_f32;

            const x_direction = x_minus1_to_1 * ctx.aspect_ratio * ctx.perspective_scale;
            const y_direction = y_minus1_to_1 * ctx.perspective_scale;

            const direction_from_camera = (rl.Vector3{
                .x = x_direction,
                .y = y_direction,
                .z = 1,
            }).normalize();

            const direction = rl.Vector3{
                .x = direction_from_camera.x * ctx.camera.Right.x + direction_from_camera.y * ctx.camera.Up.x + direction_from_camera.z * ctx.camera.Forward.x,
                .y = direction_from_camera.x * ctx.camera.Right.y + direction_from_camera.y * ctx.camera.Up.y + direction_from_camera.z * ctx.camera.Forward.y,
                .z = direction_from_camera.x * ctx.camera.Right.z + direction_from_camera.y * ctx.camera.Up.z + direction_from_camera.z * ctx.camera.Forward.z,
            };

            const col = cast_ray(ctx.camera.Postition, direction, ctx.objects, ctx.lights, 3);
            ctx.target.set_pixel_color(@intCast(screen_x), @intCast(screen_y), V3ToColor(col));
        }
    }
}

fn render(target: *Framebuffer, objects: []const Forma, lights: []const Light, camera: Camera) !void {
    const width_f32: f32 = @floatFromInt(target.width);
    const height_f32: f32 = @floatFromInt(target.height);

    const aspect_ratio = width_f32 / height_f32;
    const FOV = std.math.pi / 3.0;
    const perspective_scale = @tan(FOV * 0.5);

    // permite mas hilos concurrentes para saturar los nucleos eficientemente
    const max_threads: usize = 64;
    const cpu_cores: usize = std.Thread.getCpuCount() catch 8;
    const num_threads: usize = @min(cpu_cores * 4, max_threads);

    var threads: [max_threads]?std.Thread = [_]?std.Thread{null} ** max_threads;
    var spawned: usize = 0;

    // lanza los hilos distribuyendo lineas intercaladas entre todos los hilos
    for (0..num_threads) |i| {
        threads[i] = try std.Thread.spawn(.{}, render_rows, .{RenderContext{
            .target = target,
            .objects = objects,
            .lights = lights,
            .camera = camera,
            .thread_id = i,
            .total_threads = num_threads,
            .width_f32 = width_f32,
            .height_f32 = height_f32,
            .aspect_ratio = aspect_ratio,
            .perspective_scale = perspective_scale,
        }});
        spawned += 1;
    }

    // espera a que todos los hilos terminen de renderizar
    for (0..spawned) |i| {
        if (threads[i]) |t| t.join();
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
                // si el material reflectivo tiene color, tine lo que refleja (ejemplo: esmeralda refleja verde)
                const tinted_reflect = rl.Vector3{
                    .x = reflect_color.x * mat.Color.x,
                    .y = reflect_color.y * mat.Color.y,
                    .z = reflect_color.z * mat.Color.z,
                };
                color = color.add(tinted_reflect.scale(mat.Propiedades.Reflectividad));
            } else {
                color = color.add(celeste.scale(mat.Propiedades.Reflectividad));
            }
        }

        if (mat.Propiedades.Transparencia > 0) {
            if (max_recursion > 0) {
                if (refract(direction, hit.Normal, mat.Refractive_index)) |refract_direction| {
                    const refract_orig = hit.Punto.subtract(normal_offset);
                    const refract_color = cast_ray(refract_orig, refract_direction, objects, lights, max_recursion - 1);
                    // la luz refractada se tine con el color del material (ejemplo: esmeralda o zafiro)
                    const pass_color = rl.Vector3{
                        .x = refract_color.x * mat.Color.x,
                        .y = refract_color.y * mat.Color.y,
                        .z = refract_color.z * mat.Color.z,
                    };
                    color = color.add(pass_color.scale(mat.Propiedades.Transparencia));
                } else {
                    const tir_direction = reflect(direction, hit.Normal);
                    const tir_orig = hit.Punto.add(normal_offset);
                    const tir_color = cast_ray(tir_orig, tir_direction, objects, lights, max_recursion - 1);
                    const tir_tinted = rl.Vector3{
                        .x = tir_color.x * mat.Color.x,
                        .y = tir_color.y * mat.Color.y,
                        .z = tir_color.z * mat.Color.z,
                    };
                    color = color.add(tir_tinted.scale(mat.Propiedades.Transparencia));
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
