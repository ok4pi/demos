var delta = delta_time * (60.0 / 1000000.0);

#region Update Camera

#macro MOVE_SPEED (1.0)
#macro MOVE_ACCEL (MOVE_SPEED / 4.0)
#macro MOVE_FRICT (0.8)

var input_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var input_y = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var input_z = keyboard_check(vk_space) - keyboard_check(vk_shift);

// Update Acceleration
global.camera_sx += (lengthdir_x(input_x, global.camera_yaw_to - 90.0) + lengthdir_x(input_y, global.camera_yaw_to)) * MOVE_SPEED * delta;
global.camera_sy += (lengthdir_y(input_x, global.camera_yaw_to - 90.0) + lengthdir_y(input_y, global.camera_yaw_to)) * MOVE_SPEED * delta;
global.camera_sz += input_z * MOVE_SPEED * delta;

// Clamp Speed
var length = sqrt(global.camera_sx * global.camera_sx + global.camera_sy * global.camera_sy);

if (length > MOVE_SPEED)
{
	global.camera_sx = (global.camera_sx / length) * MOVE_SPEED;
	global.camera_sy = (global.camera_sy / length) * MOVE_SPEED;
}

global.camera_sz = clamp(global.camera_sz, -MOVE_SPEED, MOVE_SPEED);

// Update Friction
var frict = power(MOVE_FRICT, delta);

global.camera_sx *= frict;
global.camera_sy *= frict;
global.camera_sz *= frict;

// Update Position
global.camera_px += global.camera_sx * delta;
global.camera_py += global.camera_sy * delta;
global.camera_pz += global.camera_sz * delta;

// Update Look
if (window_has_focus())
{
	var cx = display_get_width()  / 2.0;
	var cy = display_get_height() / 2.0;
	
	global.camera_yaw_to   -= (display_mouse_get_x() - cx) * 0.3;
	global.camera_pitch_to -= (display_mouse_get_y() - cy) * 0.3;
	
	display_mouse_set(cx, cy);
}

// Clamp Pitch
global.camera_pitch_to = clamp(global.camera_pitch_to, -89.5, 89.5);

// Update Smooth
global.camera_yaw   = lerp_delta(global.camera_yaw,   global.camera_yaw_to,   0.7, delta);
global.camera_pitch = lerp_delta(global.camera_pitch, global.camera_pitch_to, 0.7, delta);

#endregion

#region Update Window

// Toggle Fullscreen
if (keyboard_check_pressed(vk_f4))
{
	var fullscreen = !window_get_fullscreen();
	
	window_set_fullscreen(fullscreen);
	
	if (fullscreen)
	{
		var width  = display_get_width();
		var height = display_get_height();
	}
	else
	{
		var width  = 1280;
		var height = 720;
	}
	
	surface_resize(application_surface, width, height);
	
	view_wport = width;
	view_hport = height;
	
	camera_set_view_size(view_camera, width, height);
}

// Exit Game
if (keyboard_check(vk_escape))
	game_end();

#endregion