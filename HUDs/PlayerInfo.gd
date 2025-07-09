class_name PlayerInfo extends CanvasLayer

func update_data(run_data: PlayerRunData):
	# loop through all of the buffs obtained
	for key in run_data.obtained_buffs.keys():
		# get the image 
		var img = TextureRect.new()
		img.texture = PlaceholderTexture2D.new()
		# get the buff name and amt chosen
		var buff_label = Label.new()
		buff_label.text = key
		var amt_label = Label.new()
		amt_label.text = str(run_data.obtained_buffs[key])
		# create the container
		var container = HBoxContainer.new()
		container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		container.add_child(img)
		container.add_child(buff_label)
		container.add_child(amt_label)
		# add to flow container
		$ContentContainer/HFlowContainer.add_child(container)
