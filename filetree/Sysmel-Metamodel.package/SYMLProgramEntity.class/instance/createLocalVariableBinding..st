object building
createLocalVariableBinding: localVariableBuilder
	self error: 'Cannot define local variable {1} at this place.' format: { localVariableBuilder name }