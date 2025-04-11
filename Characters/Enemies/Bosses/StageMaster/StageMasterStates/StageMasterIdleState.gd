extends State

func start_selection():
	Transitioned.emit(self, "Select")
