@tool
extends Control

@export_category('Setting')
@export_group('Config')

@export var swap_node_align := false:
	set(new_value): swap_node_align = new_value; __realign();

@export_subgroup('Icon')
@export var icon_txt: Texture2D:
	set(new_value): icon_txt = new_value; __update_icon();
@export var icon_size := Vector2i( 16, 16 ):
	set(new_value): icon_size = new_value; __update_icon();
@export var icon_valign := Control.SIZE_SHRINK_CENTER:
	set(new_value): icon_valign = new_value; __update_icon();

@export_subgroup('Text')
@export var value_prefix := '':
	set(new_value): value_prefix = new_value; __update_text();
@export var value := '0':
	set(new_value): value = new_value; __update_text();
@export var value_surfix := '':
	set(new_value): value_surfix = new_value; __update_text();

@export_subgroup('Font')
@export var font: Font:
	set(new_value): font = new_value; __update_font();

@export var value_color := Color.LIGHT_GRAY:
	set(new_value): value_color = new_value; __update_font();
@export var value_size := 12:
	set(new_value): value_size = new_value; __update_font();
@export var value_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value): value_halign = new_value; __update_font();
@export var value_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value): value_valign = new_value; __update_font();

var node_list := [
	[ 'icon', TextureRect ],
	[ '', Control ],
	[ 'value_prefix', Label ],
	[ 'value', Label ],
	[ 'value_surfix', Label ],
];

func __realign():
	var root_node := get_node( 'root' );
	var to_pos := ( node_list.size()-1 ) if swap_node_align else 0;
	for node_name in [ 'space_0', 'node_icon' ]:
		root_node.move_child( get_node( 'root/' + node_name ), to_pos );

func __update_icon():
	var icon_rect: TextureRect = get_node( 'root/node_icon' );
	icon_rect.texture = icon_txt;
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
	icon_rect.stretch_mode = TextureRect.STRETCH_SCALE;
	icon_rect.size_flags_vertical = icon_valign;
	icon_rect.custom_minimum_size = icon_size;
	UiControlsComboLib.resized( $'.' );

func __update_font():
	for item in node_list:
		if item[1] != Label: continue;
		
		var data_name: String = item[0];
		UiControlsComboLib.assign_font( get_node( 'root/node_' + data_name ), font );
		var data_group: String = data_name.split('_')[0];
		UiControlsComboLib.assign_font_color( get_node( 'root/node_' + data_name ), get( data_group + '_color' ) );
		UiControlsComboLib.assign_font_size( get_node( 'root/node_' + data_name ), get( data_group + '_size' ) );
		get_node( 'root/node_' + data_name ).horizontal_alignment = get( data_group + '_halign' );
		get_node( 'root/node_' + data_name ).vertical_alignment = get( data_group + '_valign' );

func __update_text():
	var any_updated := false;
	for item in node_list:
		if item[1] != Label: continue;
		
		var data_name: String = item[0];
		if get_node( 'root/node_' + data_name ).text == get( data_name ): continue;
		any_updated = true;
		get_node( 'root/node_' + data_name ).text = get( data_name );
	if any_updated: UiControlsComboLib.resized( $'.' );

func _ready():
	UiControlsComboLib.create_hboxaligned_node( $'.', node_list );
	__update_icon();
	__update_font();
	__update_text();
	for node in get_node('root').get_children():
		if node is Label: print( node.text )

# update size here, cannot set size correctly under _ready
var initialed := false;
func _process(_delta): if !initialed: initialed = true; UiControlsComboLib.resized( $'.' );

func _set( property, value ):
	if property == 'custom_minimum_size':
		custom_minimum_size = value;
		UiControlsComboLib.resized( $'.' );
