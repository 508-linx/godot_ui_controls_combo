@tool
class_name Editor_UiControlsCombo_Draw extends Node2D

func __format_value( input_value, digi_after_decimal := 0, show_rounded_value := false ) -> String:
	if digi_after_decimal > 0:
		var display_format := '%.' + str( digi_after_decimal ) + 'f';
		if show_rounded_value:
			return display_format % input_value;
		else:
			var div = pow( 10, digi_after_decimal );
			var display_value: float = floor( input_value * div ) / div;
			return display_format % display_value;
	else:
		return str( roundi( input_value ) if show_rounded_value else floori( input_value ) );

## NOTE: this func not perfect, I can't figure out how string size add space on top and button
func __draw_center_text( text: String, font: Font, pos: Vector2, text_size: float, text_modulate: Color ):
	if text_size <= 0: text_size = 16;
	
	var text_size_offset := font.get_string_size( text, HORIZONTAL_ALIGNMENT_CENTER, -1, text_size );
	text_size_offset.x *= -0.5;
	text_size_offset.y -= text_size;
	draw_string(
			font, pos + text_size_offset,
			text, HORIZONTAL_ALIGNMENT_CENTER,
			-1, text_size, text_modulate );
