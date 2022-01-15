var timer = get_timer() / 1000.0;

var draw = function(timer)
{
	// Render Tetra Lines
	matrix_set(matrix_world, matrix_build(0.0, 0.0, 0.0, 0.0, 0.0, timer * 0.02, 10.05, 10.05, 10.05));
	vertex_submit(global.mesh_tetra_lines, pr_linelist, -1);
	
	matrix_set(matrix_world, matrix_build(0.0, 0.0, 100.0, 0.0, 0.0, timer * -0.02, 20.1, 20.1, 40.1));
	vertex_submit(global.mesh_tetra_lines, pr_linelist, -1);
	
	matrix_set(matrix_world, matrix_build(lengthdir_x(90, timer * 0.01), lengthdir_y(90, timer * 0.01), 120 + sin(timer * 0.002) * 5, 0.0, 0.0, timer * 0.02, 10.0, 10.0, 10.0));
	vertex_submit(global.mesh_tetra_lines, pr_linelist, -1);

	matrix_set(matrix_world, matrix_build(lengthdir_x(-140, timer * 0.005), lengthdir_y(110, timer * 0.005), 120 + sin(timer * 0.0012) * 10, 0.0, 0.0, timer * 0.007, 15.0, 15.0, 20.0));
	vertex_submit(global.mesh_tetra_lines, pr_linelist, -1);
	
	// Render World Lines
	matrix_set(matrix_world, matrix_build(0.0, 0.0, 0.0, 0.0, 0.0, timer * 0.01, 10.05, 10.05, 10.05));
	vertex_submit(global.mesh_world_lines, pr_linelist, -1);
	
	matrix_set(matrix_world, matrix_build(0.0, 0.0, -70.0, 0.0, 0.0, -timer * 0.01, 40.05, 40.05, -10.05));
	vertex_submit(global.mesh_world_lines, pr_linelist, -1);
}

#region Render Stars

shader_set(sh_sky);
shader_set_uniform_f(global.u_sh_sky_time, timer * 0.1);
texture_set_stage(1, sprite_get_texture(spr_eden, 0));

gpu_set_zwriteenable(false);
gpu_set_cullmode(cull_clockwise);
set_projection();
draw_clear(c_black);

matrix_set(matrix_world, matrix_build(global.camera_px, global.camera_py, global.camera_pz, 0, 0, 0, 50, 50, 50));
vertex_submit(global.mesh_dome, pr_trianglelist, sprite_get_texture(spr_stars, 0));
matrix_set(matrix_world, global.matrix_identity);

shader_reset();
gpu_set_cullmode(cull_counterclockwise);
gpu_set_zwriteenable(true);

#endregion

#region Render Scene

// Setup Shader
shader_set(sh_default);

// Render Tetrahedron
matrix_set(matrix_world, matrix_build(0.0, 0.0, 0.0, 0.0, 0.0, timer * 0.02, 10.0, 10.0, 10.0));
vertex_submit(global.mesh_tetra_tris, pr_trianglelist, -1);

matrix_set(matrix_world, matrix_build(0.0, 0.0, 100.0, 0.0, 0.0, timer * -0.02, 20.0, 20.0, 40.0));
vertex_submit(global.mesh_tetra_tris, pr_trianglelist, -1);

matrix_set(matrix_world, matrix_build(lengthdir_x(90, timer * 0.01), lengthdir_y(90, timer * 0.01), 120 + sin(timer * 0.002) * 5, 0.0, 0.0, timer * 0.02, 10.0, 10.0, 10.0));
vertex_submit(global.mesh_tetra_tris, pr_trianglelist, -1);

matrix_set(matrix_world, matrix_build(lengthdir_x(90, timer * 0.01), lengthdir_y(90, timer * 0.01), 120 + sin(timer * 0.002) * 5, 0.0, 0.0, timer * 0.02, 10.0, 10.0, 10.0));
vertex_submit(global.mesh_tetra_tris, pr_trianglelist, -1);

matrix_set(matrix_world, matrix_build(lengthdir_x(-140, timer * 0.005), lengthdir_y(110, timer * 0.005), 120 + sin(timer * 0.0012) * 10, 0.0, 0.0, timer * 0.007, 15.0, 15.0, 20.0));
vertex_submit(global.mesh_tetra_tris, pr_trianglelist, -1);

// Reset State
shader_reset();
matrix_set(matrix_world, global.matrix_identity);

#endregion

#region Render Lines

// Setup Shader
shader_set(sh_lines);
set_projection();

draw(timer);

// Reset Shader
shader_reset();
matrix_set(matrix_world, global.matrix_identity);

#endregion

#region Render Bloom

if (!surface_exists(global.bloom_surface))   global.bloom_surface   = surface_create(global.bloom_surface_width, global.bloom_surface_height);
if (!surface_exists(global.bloom_temporary)) global.bloom_temporary = surface_create(global.bloom_surface_width, global.bloom_surface_height);

// Setup Shader
shader_set(sh_lines);
surface_set_target(global.bloom_surface);
draw_clear(c_black);

set_projection();

draw(timer);

// Reset Shader
shader_reset();
matrix_set(matrix_world, global.matrix_identity);
surface_reset_target();

// Blur X
surface_set_target(global.bloom_temporary);
	draw_clear(c_black);
	shader_set(sh_blur_x);
		shader_set_uniform_f(global.u_sh_blur_x_size, 1 / (global.bloom_surface_width * 1));
		draw_surface(global.bloom_surface, 0, 0);
	shader_reset();
surface_reset_target();

// Blur Y
surface_set_target(global.bloom_surface);
	draw_clear(c_black);
	shader_set(sh_blur_y);
		shader_set_uniform_f(global.u_sh_blur_y_size, 1 / (global.bloom_surface_height * 1));
		draw_surface(global.bloom_temporary, 0, 0);
	shader_reset();
surface_reset_target();

#endregion