class_name PlayerInfo extends CanvasLayer

var icon_path = "res://Resources/icons/ui/"
var readable_string_dict = {
	"sunder_dmg": {
		"type": "damage buff",
		"element": "sunder"
	},
	"sunder_multicast": {
		"type": "multicasts",
		"element": "sunder"
	},
	"entropy_spd": {
		"type": "speed buff",
		"element": "entropy"
	},
	"entropy_cr": {
		"type": "crit rate buff",
		"element": "entropy"
	},
	"construct_size": {
		"type": "size buff",
		"element": "construct"
	},
	"construct_passthru": {
		"type": "passes thru walls",
		"element": "construct"
	},
	"growth_lifetime": {
		"type": "lifetime buff",
		"element": "growth"
	},
	"growth_rpotency": {
		"type": "reaction potency buff",
		"element": "growth"
	},
	"flow_cd": {
		"type": "cooldown reduction",
		"element": "flow"
	},
	"flow_size": {
		"type": "size buff",
		"element": "flow"
	},
	"wither_lifetime": {
		"type": "lifetime buff",
		"element": "wither"
	},
	"wither_size": {
		"type": "size buff",
		"element": "wither"
	}
}

func update_data(run_data: PlayerRunData):
	# loop through all of the buffs obtained
	for key in run_data.obtained_buffs.keys():
		var img = TextureRect.new()
		var buff_label = Label.new()
		var amt_label = Label.new()
		if key in readable_string_dict.keys():
			# get the image and verify it exists
			img.texture = load(icon_path + readable_string_dict[key]["element"] + "_icon.png")
			if !img.texture:
				img.texture = PlaceholderTexture2D.new()
			# get the buff name and amt chosen
			buff_label.text = readable_string_dict[key]["element"] + " " + readable_string_dict[key]["type"] + ": "
			amt_label.text = str(run_data.obtained_buffs[key])
		else:
			img.texture = PlaceholderTexture2D.new()
			buff_label.text = key + ": "
			amt_label.text = str(run_data.obtained_buffs[key])
			printerr("Unidentifiable buff found for: \"" + key + "\". Could not display buff.")
		# create the container
		var container = HBoxContainer.new()
		container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		container.add_child(img)
		container.add_child(buff_label)
		container.add_child(amt_label)
		# add to flow container
		$ContentContainer/HFlowContainer.add_child(container)
