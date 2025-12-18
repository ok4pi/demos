#region Initialize Engine

// Enable Release Mode
// gml_release_mode(true);

// Unlock Framerate
display_set_timing_method(tm_systemtiming);
window_enable_borderless_fullscreen(true);

#endregion

#region Initialize Input

#endregion

#region Initialize Render

// Setup Resources
#region Initialize Shader Uniforms

global.u_sh_blur_x_size = shader_get_uniform(sh_blur_x, "size");
global.u_sh_blur_y_size = shader_get_uniform(sh_blur_y, "size");
global.u_sh_sky_time    = shader_get_uniform(sh_sky,    "time");

#endregion

#region Initialize Vertex Formats

// Default
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();

global.vertex_format_default = vertex_format_end();

// Sky
vertex_format_begin();
vertex_format_add_custom(vertex_type_float4, vertex_usage_position);

global.vertex_format_sky = vertex_format_end();

#endregion

// Setup Globals
global.matrix_identity = matrix_build_identity();

global.bloom_surface_width  = view_wport / 3;
global.bloom_surface_height = view_hport / 3;
global.bloom_surface        = -1;
global.bloom_temporary      = -1;

// Setup Rasterizer State
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_cullmode(cull_counterclockwise);

// Setup Sampler State
gpu_set_tex_filter(true);
gpu_set_tex_repeat(true);
gpu_set_tex_mip_filter(tf_anisotropic);
gpu_set_tex_max_aniso(16);

// Disable Application Surface
// application_surface_enable(false);

// Enable MSAA
// display_reset(8.0, false);

#endregion

#region Initialize Camera

global.camera_px       = 0.0;
global.camera_py       = 0.0;
global.camera_pz       = 0.0;

global.camera_sx       = 0.0;
global.camera_sy       = 0.0;
global.camera_sz       = 0.0;

global.camera_yaw      = 0.0;
global.camera_yaw_to   = 0.0;
global.camera_pitch    = 0.0;
global.camera_pitch_to = 0.0;

#endregion

#region Initialize Models

global.mesh_tetra_tris  = vertex_buffer_load("models/tetrahedron.buf");
global.mesh_dome        = vertex_buffer_load("models/dome.buf");
global.mesh_tetra_lines = vertex_create_buffer();
global.mesh_world_lines = vertex_create_buffer();

#endregion

#region Initialize Tetra Lines

var vb = global.mesh_tetra_lines;

// Begin Vertex Buffer
vertex_begin(vb, global.vertex_format_default);

vertex_pos_col(vb, 0, 0, 2, 0xD77BEA); vertex_pos_col(vb,  1.6,  1.6, 0, 0xF06075);
vertex_pos_col(vb, 0, 0, 2, 0xD77BEA); vertex_pos_col(vb,  1.6, -1.6, 0, 0xF06075);
vertex_pos_col(vb, 0, 0, 2, 0xD77BEA); vertex_pos_col(vb, -1.6,  1.6, 0, 0xF06075);
vertex_pos_col(vb, 0, 0, 2, 0xD77BEA); vertex_pos_col(vb, -1.6, -1.6, 0, 0xF06075);

vertex_pos_col(vb,  -1.6,  1.6, 0, 0xF06075); vertex_pos_col(vb,  1.6,  1.6, 0, 0xF06075);
vertex_pos_col(vb,   1.6, -1.6, 0, 0xF06075); vertex_pos_col(vb,  1.6,  1.6, 0, 0xF06075);
vertex_pos_col(vb,  -1.6, -1.6, 0, 0xF06075); vertex_pos_col(vb, -1.6,  1.6, 0, 0xF06075);
vertex_pos_col(vb,  -1.6, -1.6, 0, 0xF06075); vertex_pos_col(vb,  1.6, -1.6, 0, 0xF06075);

vertex_pos_col(vb,  1.6,  1.6, 0, 0xF06075); vertex_pos_col(vb, 0, 0, -2, 0xF8E770);
vertex_pos_col(vb,  1.6, -1.6, 0, 0xF06075); vertex_pos_col(vb, 0, 0, -2, 0xF8E770);
vertex_pos_col(vb, -1.6,  1.6, 0, 0xF06075); vertex_pos_col(vb, 0, 0, -2, 0xF8E770);
vertex_pos_col(vb, -1.6, -1.6, 0, 0xF06075); vertex_pos_col(vb, 0, 0, -2, 0xF8E770);

// Finish Vertex Buffer
vertex_end(vb);

#endregion

#region Initialize World Lines

var vb = global.mesh_world_lines;

// Begin Vertex Buffer
vertex_begin(vb, global.vertex_format_default);

for (var i = 0; i < 360; i += 4)
{
	var color = 0xF06075;
	
	// start from base
	vertex_pos_col(vb, 0, 0, -3.2, color); vertex_pos_col(vb, lengthdir_x(2.2, i), lengthdir_y(2.2, i), -1, color);
	
	// go inward
	vertex_pos_col(vb, lengthdir_x(2.2, i), lengthdir_y(2.2, i), -1, color); vertex_pos_col(vb, lengthdir_x(2.0, i), lengthdir_y(2.0, i), -0.8, color);
	
	// go up a little
	vertex_pos_col(vb, lengthdir_x(2.0, i), lengthdir_y(2.0, i), -0.8, color); vertex_pos_col(vb, lengthdir_x(2.0, i), lengthdir_y(2.0, i), -0.6, color);
	
	// go outward
	vertex_pos_col(vb, lengthdir_x(2.0, i), lengthdir_y(2.0, i), -0.6, color); vertex_pos_col(vb, lengthdir_x(2.5, i), lengthdir_y(2.5, i), 0.0, color);
	
	// go up a little outward
	vertex_pos_col(vb, lengthdir_x(2.5, i), lengthdir_y(2.5, i), 0.0, color); vertex_pos_col(vb, lengthdir_x(3.0, i), lengthdir_y(3.0, i), 0.2, color);
	
	// go back down again
	vertex_pos_col(vb, lengthdir_x(3.0, i), lengthdir_y(3.0, i), 0.2, color); vertex_pos_col(vb, lengthdir_x(3.5, i), lengthdir_y(3.5, i), 0.0, color);
	
	// go up a lot again
	vertex_pos_col(vb, lengthdir_x(3.5, i), lengthdir_y(3.5, i), 0.0, color); vertex_pos_col(vb, lengthdir_x(4.5, i), lengthdir_y(4.5, i), 1.5, color);
	
	// start crazy shit
	for (var j = 0; j < 50; j++)
	{
		var js = j * 0.5;
		var jz = j * 0.5 + sin(j) * 0.2;
		var ja = i;
		var color = merge_color(0xF06075, 0xF8E770, j / 50);
		
		vertex_pos_col(vb, lengthdir_x(js + 4.5, ja),     lengthdir_y(js + 4.5, ja),     jz + 1.5, color); vertex_pos_col(vb, lengthdir_x(js + 4.4, ja + 2), lengthdir_y(js + 4.4, ja + 2), jz + 1.4, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.4, ja + 2), lengthdir_y(js + 4.4, ja + 2), jz + 1.4, color); vertex_pos_col(vb, lengthdir_x(js + 4.5, ja + 4), lengthdir_y(js + 4.5, ja + 4), jz + 1.5, color);
		
		if (j != 0)
		{
			vertex_pos_col(vb, lengthdir_x(js + 4.4, ja + 2), lengthdir_y(js + 4.4, ja + 2), jz + 1.4, color); vertex_pos_col(vb, lengthdir_x(js + 4.3, ja + 2), lengthdir_y(js + 4.3, ja + 2), jz + 1.5, color);
		}
		
		vertex_pos_col(vb, lengthdir_x(js + 4.5, ja), lengthdir_y(js + 4.5, ja), jz + 1.5, color); vertex_pos_col(vb, lengthdir_x(js + 4.5, ja), lengthdir_y(js + 4.5, ja), jz + 1.6, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.5, ja), lengthdir_y(js + 4.5, ja), jz + 1.6, color); vertex_pos_col(vb, lengthdir_x(js + 4.6, ja), lengthdir_y(js + 4.6, ja), jz + 1.7, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.6, ja), lengthdir_y(js + 4.6, ja), jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.7, ja), lengthdir_y(js + 4.7, ja), jz + 1.7, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.7, ja), lengthdir_y(js + 4.7, ja), jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.8, ja), lengthdir_y(js + 4.8, ja), jz + 1.6, color);
		
		// ridge 1
		vertex_pos_col(vb, lengthdir_x(js + 4.5, ja),     lengthdir_y(js + 4.5, ja),     jz + 1.6, color); vertex_pos_col(vb, lengthdir_x(js + 4.5, ja + 2), lengthdir_y(js + 4.5, ja + 2), jz + 1.7, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.5, ja + 2), lengthdir_y(js + 4.5, ja + 2), jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.5, ja + 4), lengthdir_y(js + 4.5, ja + 4), jz + 1.6, color);
		
		// ridge 2
		vertex_pos_col(vb, lengthdir_x(js + 4.6, ja),     lengthdir_y(js + 4.6, ja),     jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.6, ja + 2), lengthdir_y(js + 4.6, ja + 2), jz + 1.8, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.6, ja + 2), lengthdir_y(js + 4.6, ja + 2), jz + 1.8, color); vertex_pos_col(vb, lengthdir_x(js + 4.6, ja + 4), lengthdir_y(js + 4.6, ja + 4), jz + 1.7, color);
		
		// ridge 3
		vertex_pos_col(vb, lengthdir_x(js + 4.7, ja),     lengthdir_y(js + 4.7, ja),     jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.7, ja + 2), lengthdir_y(js + 4.7, ja + 2), jz + 1.8, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.7, ja + 2), lengthdir_y(js + 4.7, ja + 2), jz + 1.8, color); vertex_pos_col(vb, lengthdir_x(js + 4.7, ja + 4), lengthdir_y(js + 4.7, ja + 4), jz + 1.7, color);
		
		// ridge 4
		vertex_pos_col(vb, lengthdir_x(js + 4.8, ja),     lengthdir_y(js + 4.8, ja),     jz + 1.6, color); vertex_pos_col(vb, lengthdir_x(js + 4.8, ja + 2), lengthdir_y(js + 4.8, ja + 2), jz + 1.7, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.8, ja + 2), lengthdir_y(js + 4.8, ja + 2), jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.8, ja + 4), lengthdir_y(js + 4.8, ja + 4), jz + 1.6, color);
		
		// bridges
		vertex_pos_col(vb, lengthdir_x(js + 4.5, ja + 2), lengthdir_y(js + 4.5, ja + 2), jz + 1.7, color); vertex_pos_col(vb, lengthdir_x(js + 4.6, ja + 2), lengthdir_y(js + 4.6, ja + 2), jz + 1.8, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.6, ja + 2), lengthdir_y(js + 4.6, ja + 2), jz + 1.8, color); vertex_pos_col(vb, lengthdir_x(js + 4.7, ja + 2), lengthdir_y(js + 4.7, ja + 2), jz + 1.8, color);
		vertex_pos_col(vb, lengthdir_x(js + 4.7, ja + 2), lengthdir_y(js + 4.7, ja + 2), jz + 1.8, color); vertex_pos_col(vb, lengthdir_x(js + 4.8, ja + 2), lengthdir_y(js + 4.8, ja + 2), jz + 1.7, color);
		
		// journey to the next one
		vertex_pos_col(vb, lengthdir_x(js + 4.8, ja), lengthdir_y(js + 4.8, ja), jz + 1.6, color); vertex_pos_col(vb, lengthdir_x(js + 5.0, ja), lengthdir_y(js + 5.0, ja), jz + 1.8, color);
	}
}

// Finish Vertex Buffer
vertex_end(vb);

#endregion