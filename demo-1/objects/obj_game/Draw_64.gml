gpu_set_blendmode_ext(bm_one, bm_dest_alpha);
	// shader_set(sh_bl_draw);
	// 	shader_set_uniform_f(global.__bl_uniform_sh_bl_draw_color, color_get_red(argument8) / 255, color_get_green(argument8) / 255, color_get_blue(argument8) / 255, 1);
		draw_surface_stretched_ext(global.bloom_surface, 0, 0, view_get_wport(0), view_get_hport(0), merge_color(c_white, c_black, 0.2), 1.0);
	// shader_reset();
gpu_set_blendmode(bm_normal);

// if (surface_exists(global.bloom_surface))
// 	draw_surface_stretched(global.bloom_surface, 0, 0, global.bloom_surface_width, global.bloom_surface_height);

// gpu_set_tex_filter(true);
// draw_surface_stretched(global.bloom_surface, 0, 0, view_wport, view_hport);

draw_set_font(fnt_main);
draw_text(4.0, view_hport - 25, "FPS: "   + string(fps));
draw_text(4.0, view_hport - 13, "Delta: " + string(delta_time / 1000.0) + " ms");