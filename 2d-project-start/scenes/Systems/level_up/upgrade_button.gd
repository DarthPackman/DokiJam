extends TextureButton

@onready var weapon_button: PanelContainer	= $background
@onready var name_label: Label = $WeaponName
@onready var empty_icon: TextureRect = $Icon

func update_weapon_button(weapon_name: String, weapon_icon: Texture2D):
	# Update text
	name_label.text = weapon_name
	
	# Update icon
	empty_icon.texture = weapon_icon
	
