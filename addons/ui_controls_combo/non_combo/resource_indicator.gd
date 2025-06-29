@tool
class_name Editor_UiControlsCombo_ResourceIndicator extends Editor_UiControlsCombo_Draw

enum DRAW_ALIGN { BEGIN, CENTER, END }

@export_category('Setting')
## allow display_value / display_color / background_color getter call queue_redraw()
@export var getter_redraw := true;
## use Vector2 to store value, [ x == current value ] and [ y == max value ]
@export var display_value: Array[Vector2]:
	set(new_value):
		display_value = new_value;
		queue_redraw();
	get():
		if getter_redraw: queue_redraw();
		return display_value;
## default to Color.WHITE while can't get valid value
@export var display_color: Array[Color]:
	set(new_value):
		display_color = new_value;
		queue_redraw();
	get():
		if getter_redraw: queue_redraw();
		return display_color;
## default to Color.DIM_GRAY while NOT SET any value, use lastest value while size() <= display_value.size()
@export var background_color: Array[Color]:
	set(new_value):
		background_color = new_value;
		queue_redraw();
	get():
		if getter_redraw: queue_redraw();
		return background_color;

@export_group('Config')
@export var draw_align := DRAW_ALIGN.CENTER:
	set(new_value): draw_align = new_value; queue_redraw();
@export var draw_vertical := false:
	set(new_value): draw_vertical = new_value; queue_redraw();
@export var draw_fill_invert := false:
	set(new_value): draw_fill_invert = new_value; queue_redraw();
@export var draw_item_size := Vector2( 40.0, 4.0 ):
	set(new_value): draw_item_size = abs(new_value); queue_redraw();
@export var draw_item_separation := 0.0:
	set(new_value): draw_item_separation = new_value; queue_redraw();
@export var draw_offset := Vector2.ZERO:
	set(new_value): draw_offset = new_value; queue_redraw();

@export_group('Value Text')
@export var draw_value := false:
	set(new_value): draw_value = new_value; queue_redraw(); update_configuration_warnings();
@export var value_sperator := '/':
	set(new_value): value_sperator = new_value; queue_redraw();
@export var value_font: Font:
	set(new_value): value_font = new_value; queue_redraw(); update_configuration_warnings();
@export var value_size := 0.0:
	set(new_value): value_size = abs(new_value); queue_redraw();
@export var value_modulate := Color.WHITE:
	set(new_value): value_modulate = new_value; queue_redraw();
@export var value_display_decimal := 2:
	set(new_value): value_display_decimal = abs(new_value); queue_redraw();
@export var value_rounded := true:
	set(new_value): value_rounded = new_value; queue_redraw();

func _get_configuration_warnings():
	if draw_value and !( value_font is Font ):
		return ['you HAVE turn on [ draw_value ] but HAVE NOT set any Font\nthis Node DOSE NOT DRAW ANY VALUE until you set any Font'];

func _draw():
	var LINE_VH_MUL := Vector2( 1.0, 0.0 ) if draw_vertical else Vector2( 0.0, 1.0 );
	var SIZE_VH_MUL := Vector2( LINE_VH_MUL.y, LINE_VH_MUL.x );
	for idx in range( display_value.size() ):
		var item_col := Color.WHITE;
		if idx < display_color.size():
			item_col = display_color[ idx ];
		
		var bg_col := Color.DIM_GRAY;
		if background_color.size() > 0:
			bg_col = background_color[ min( idx, background_color.size()-1 ) ];
		
		var unit_value: float = clamp( display_value[ idx ].x / display_value[ idx ].y, 0.0, 1.0 );
		var line_offset := float(idx) * ( draw_item_separation * LINE_VH_MUL + draw_item_size * LINE_VH_MUL );
		match draw_align:
			DRAW_ALIGN.BEGIN:
				line_offset += draw_item_size * 0.5 * LINE_VH_MUL;
			DRAW_ALIGN.CENTER:
				line_offset -= draw_item_size * ( float( display_value.size() ) * 0.5 - 0.5 ) * LINE_VH_MUL;
				line_offset -= Vector2.ONE * draw_item_separation * float( display_value.size()-1 ) * LINE_VH_MUL * 0.5;
			DRAW_ALIGN.END:
				line_offset -= draw_item_size * ( float( display_value.size() ) - 0.5 ) * LINE_VH_MUL;
				line_offset -= Vector2.ONE * draw_item_separation * float( display_value.size()-1 ) * LINE_VH_MUL;
		var line_size := draw_item_size * 0.5 * SIZE_VH_MUL;
		var line_start_pos := draw_offset + line_offset - line_size;
		var line_end_pos := draw_offset + line_offset + line_size;
		if draw_fill_invert:
			var temp_pos := line_start_pos;
			line_start_pos = line_end_pos;
			line_end_pos = temp_pos;
		var line_unit_pos := line_start_pos + ( line_end_pos - line_start_pos ) * unit_value;
		var line_width := ( draw_item_size * LINE_VH_MUL ).length();
		
		draw_line( line_start_pos, line_end_pos, bg_col, line_width );
		draw_line( line_start_pos, line_unit_pos, item_col, line_width );
		
		if draw_value and value_font is Font:
			var text_size := value_size if value_size > 0.0 else line_width;
			for v in [
				[ __format_value( display_value[ idx ].x, value_display_decimal, value_rounded ), 0.25 ],
				[ value_sperator, 0.5 ],
				[ __format_value( display_value[ idx ].y, value_display_decimal, value_rounded ), 0.75 ],
			]:
				var draw_pos: float = v[1];
				if draw_fill_invert: draw_pos = 1.0 - draw_pos;
				__draw_center_text(
						v[0], value_font,
						line_start_pos + ( line_end_pos - line_start_pos ) * draw_pos,
						text_size, value_modulate );
