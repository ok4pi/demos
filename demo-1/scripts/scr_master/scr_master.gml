function lerp_delta(a, b, t, d)
{
	return lerp(a, b, 1.0 - exp(-t * d));
}

function vertex_buffer_load(path)
{
	var data = buffer_load(path);
	var mesh = vertex_create_buffer_from_buffer(data, global.vertex_format_default);
	
	// Delete Data
	buffer_delete(data);
	
	// Freeze Mesh
	vertex_freeze(mesh);
	
	// Success
	return mesh;
}

function vertex_pos_col(vb, x, y, z, color)
{
	vertex_position_3d(vb, x, y, z);
	vertex_normal(vb, 0, 0, 0);
	vertex_texcoord(vb, 0, 0);
	vertex_color(vb, color, 1);
}

function set_projection()
{
	matrix_set(matrix_view, matrix_build_lookat(global.camera_px, global.camera_py, global.camera_pz, global.camera_px + dcos(global.camera_yaw), global.camera_py - dsin(global.camera_yaw), global.camera_pz + dtan(global.camera_pitch), 0.0, 0.0, 1.0));
	matrix_set(matrix_projection, matrix_build_projection_perspective_fov(90.0, view_wport / view_hport, 0.1, 5000.0));
}

function build_dome(x1, y1, z1, x2, y2, z2, steps)
{
	var xx = (x1 + x2) / 2.0;
	var yy = (y1 + y2) / 2.0;
	var zz = (z1 + z2) / 2.0;
	var xl = (x2 - xx);
	var yl = (y2 - yy);
	var zl = (z2 - zz);
	var a  = (2.0 * pi) / steps;
	var vb = vertex_create_buffer();
	
	// Begin Buffer
	vertex_begin(vb, global.vertex_format_sky);
	
	// Build Buffer
	for (var i = 0.0; i < pi * 2.0; i += a)
	for (var j = 0.0; j < pi;       j += a)
	{
		var b, c;
		var t1 = (j)     / pi;
		var t2 = (j + a) / pi;
		
		if (j < pi / 2.0)
		{
			b = t1;
			c = t2;
		}
		else
		{
			b = 1.0 - (j)     / pi;
			c = 1.0 - (j + a) / pi;
		}
		
		vertex_float4(vb, xx + xl * cos(i)     * sin(j),     yy - yl * sin(i)     * sin(j),     zz + zl * cos(j),     t1);
		vertex_float4(vb, xx + xl * cos(i)     * sin(j + a), yy - yl * sin(i)     * sin(j + a), zz + zl * cos(j + a), t2);
		vertex_float4(vb, xx + xl * cos(i + a) * sin(j),     yy - yl * sin(i + a) * sin(j),     zz + zl * cos(j),     t1);
		
		vertex_float4(vb, xx + xl * cos(i)     * sin(j + a), yy - yl * sin(i)     * sin(j + a), zz + zl * cos(j + a), t2);
		vertex_float4(vb, xx + xl * cos(i + a) * sin(j + a), yy - yl * sin(i + a) * sin(j + a), zz + zl * cos(j + a), t2);
		vertex_float4(vb, xx + xl * cos(i + a) * sin(j),     yy - yl * sin(i + a) * sin(j),     zz + zl * cos(j),     t1);
	}
	
	// Finish Buffer
	vertex_end(vb);
	vertex_freeze(vb);
	
	// Success
	return vb;
}