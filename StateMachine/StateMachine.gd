class_name StateMachine extends Node

@export var initial_state: State

# current state
var current_state: State
# the states in the state machine
var states: Dictionary = {}

# Ready function called when node loaded
func _ready():
	# get all children of this node (states) and put into dict
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(Callable(self, "on_child_transition"))
	# assign init state and call init
	if initial_state:
		initial_state.enter()
		current_state = initial_state

# called every frame
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

# called every physics frame
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# handles chaning the child transition
func on_child_transition(state: State, new_state_name: String):
	print("leaving state: " + str(state) + " | entering state: " + new_state_name)
	# check current state
	if state != current_state:
		return
	# get the new state and validate
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	# assign the current state and transition
	if current_state:
		current_state.exit()
	new_state.enter()
	# reassign
	current_state = new_state
