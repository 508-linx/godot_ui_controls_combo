@tool
class_name Editor_UiControlsCombo_Basic_Status extends Editor_UiControlsCombo_Basic

@export_category('Setting')
@export var swap_info_align := false:
	set(new_value):
		swap_info_align = new_value;
		swap_all_align();
@export var change_icon_align := false:
	set(new_value):
		change_icon_align = new_value;
		swap_all_align();

@export_group('Container')
@export var info_container_separation := 4.0:
	set(new_value):
		info_container_separation = new_value;
		update_container();

@export_group('Icon')
@export var icon_txt: Texture2D:
	set(new_value):
		icon_txt = new_value;
		update_texturerect();
@export var icon_size := Vector2( 16, 16 ):
	set(new_value):
		icon_size = new_value;
		update_texturerect();
@export var icon_valign := Control.SIZE_SHRINK_CENTER:
	set(new_value):
		icon_valign = new_value;
		update_texturerect();
@export var icon_modulate := Color.WHITE:
	set(new_value):
		icon_modulate = new_value;
		update_texturerect();

@export_group('Label')
@export_subgroup('Text')
@export var title_prefix := '':
	set(new_value):
		title_prefix = new_value;
		update_label();
@export var title := 'Status Name':
	set(new_value):
		title = new_value;
		update_label();
@export var title_surfix := '':
	set(new_value):
		title_surfix = new_value;
		update_label();
@export var value_prefix := '[':
	set(new_value):
		value_prefix = new_value;
		update_label();
@export var value := '0':
	set(new_value):
		value = new_value;
		update_label();
@export var value_surfix := ']':
	set(new_value):
		value_surfix = new_value;
		update_label();

@export_subgroup('Font')
## set this value assign to all font
@export var font: Font:
	set(new_value):
		font = new_value;
		if !stop_sync_font:
			stop_sync_font = true;
			title_font = new_value;
			value_font = new_value;
			stop_sync_font = false;
			update_font();
@export var title_font: Font:
	set(new_value):
		title_font = new_value;
		if !stop_sync_font:
			stop_sync_font = true;
			font = null;
			stop_sync_font = false;
			update_font();
@export var value_font: Font:
	set(new_value):
		value_font = new_value;
		if !stop_sync_font:
			stop_sync_font = true;
			font = null;
			stop_sync_font = false;
			update_font();

var stop_sync_font := false;

@export var title_color := Color.LIGHT_GRAY:
	set(new_value):
		title_color = new_value;
		update_font();
@export var title_size := 16:
	set(new_value):
		title_size = new_value;
		update_font();
@export var title_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value):
		title_halign = new_value;
		update_font();
@export var title_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value):
		title_valign = new_value;
		update_font();

@export var value_color := Color.LIGHT_GRAY:
	set(new_value):
		value_color = new_value;
		update_font();
@export var value_size := 16:
	set(new_value):
		value_size = new_value;
		update_font();
@export var value_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value):
		value_halign = new_value;
		update_font();
@export var value_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value):
		value_valign = new_value;
		update_font();

var node_list := [
	[ 'info_container',	'align_info',			'',				HBoxContainer ],
	[ 'icon',			'texture_icon',			'align_info',	TextureRect ],
	[ 'title_prefix',	'label_title_prefix',	'align_info',	Label ],
	[ 'title',			'label_title',			'align_info',	Label ],
	[ 'title_surfix',	'label_title_surfix',	'align_info',	Label ],
	[ 'info',			'space_info',			'align_info',	Control ],
	[ 'value_prefix',	'label_value_prefix',	'align_info',	Label ],
	[ 'value',			'label_value',			'align_info',	Label ],
	[ 'value_surfix',	'label_value_surfix',	'align_info',	Label ],
];

func _ready():
	create_node_index( node_list );
	super._ready();
