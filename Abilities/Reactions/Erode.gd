class_name ErodeReaction extends AreaReaction

var BASE_SIZE = 32.0

func init(reaction_components: Dictionary):
	spawn_reaction_name("erode!", get_parent(), Color("#ffd966"), Color("#82b1ff"))
	super(reaction_components)

func _ready():
	
