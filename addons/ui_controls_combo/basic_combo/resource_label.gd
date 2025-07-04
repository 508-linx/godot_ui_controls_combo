@tool
extends 'res://addons/ui_controls_combo/combo_base.gd'

@export_category('Setting')
@export_group('Config')

@export var swap_node_align := false:
	set(new_value):
		swap_node_align = new_value;
		swap_align( node_list, swap_node_align, swap_icon_align );
@export var swap_icon_align := false:
	set(new_value):
		swap_icon_align = new_value;
		swap_align( node_list, swap_node_align, swap_icon_align );

@export_subgroup('Icon')
@export var icon_txt: Texture2D:
	set(new_value):
		icon_txt = new_value;
		update_icon( node_list );
@export var icon_size := Vector2( 16, 16 ):
	set(new_value):
		icon_size = new_value;
		update_icon( node_list );
@export var icon_valign := Control.SIZE_SHRINK_CENTER:
	set(new_value):
		icon_valign = new_value;
		update_icon( node_list );
@export var icon_modulate := Color.WHITE:
	set(new_value):
		icon_modulate = new_value;
		update_icon( node_list );

@export_subgroup('Text')
@export var title_prefix := '':
	set(new_value):
		title_prefix = new_value;
		update_text( node_list );
@export var title := 'Resource Name':
	set(new_value):
		title = new_value;
		update_text( node_list );
@export var title_surfix := '':
	set(new_value):
		title_surfix = new_value;
		update_text( node_list );
@export var value_prefix := '[':
	set(new_value):
		value_prefix = new_value;
		update_text( node_list );
@export var value_cur := '0':
	set(new_value):
		value_cur = new_value;
		update_text( node_list );
		update_bar();
@export var value_sep := '/':
	set(new_value):
		value_sep = new_value;
		update_text( node_list );
@export var value_max := '0':
	set(new_value):
		value_max = new_value;
		update_text( node_list );
		update_bar();
@export var value_surfix := ']':
	set(new_value):
		value_surfix = new_value;
		update_text( node_list );

@export_subgroup('Font')
@export var font: Font:
	set(new_value):
		font = new_value;
		update_font( node_list );

@export var title_color := Color.LIGHT_GRAY:
	set(new_value):
		title_color = new_value;
		update_font( node_list );
@export var title_size := 16:
	set(new_value):
		title_size = new_value;
		update_font( node_list );
@export var title_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value):
		title_halign = new_value;
		update_font( node_list );
@export var title_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value):
		title_valign = new_value;
		update_font( node_list );

@export var value_color := Color.LIGHT_GRAY:
	set(new_value):
		value_color = new_value;
		update_font( node_list );
@export var value_size := 16:
	set(new_value):
		value_size = new_value;
		update_font( node_list );
@export var value_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value):
		value_halign = new_value;
		update_font( node_list );
@export var value_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value):
		value_valign = new_value;
		update_font( node_list );

var node_list := [
	[ 'icon',			'texture_icon',			TextureRect ],
	[ 'title_prefix',	'label_title_prefix',	Label ],
	[ 'title',			'label_title',			Label ],
	[ 'title_surfix',	'label_title_surfix',	Label ],
	[ '',				'space_0',				Control ],
	[ 'value_prefix',	'label_value_prefix',	Label ],
	[ 'value_cur',		'label_value_cur',		Label ],
	[ 'value_sep',		'label_value_sep',		Label ],
	[ 'value_max',		'label_value_max',		Label ],
	[ 'value_surfix',	'label_value_surfix',	Label ],
];

func _ready():
	var root_node := VBoxContainer.new();
	root_node.name = 'root';
	root_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	add_child( root_node );
	
	create_hboxaligned_node( node_list, get_node('root') );
	
	var progress_bar := ProgressBar.new();
	progress_bar.name = 'progress';
	progress_bar.show_percentage = false;
	root_node.add_child( progress_bar );
	update_bar();
	
	minimum_size_changed.connect( resized_node );
	resized.connect( resized_node );

func update_bar():
	var node: ProgressBar = get_node('root/progress');
	if node == null: return;
	node.value = value_cur.to_float();
	node.max_value = value_max.to_float();
