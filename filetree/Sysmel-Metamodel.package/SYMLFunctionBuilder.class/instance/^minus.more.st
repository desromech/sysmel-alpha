meta methods
-> aReturnType
	<compileTime>
	aReturnType type isMetaType ifFalse: [
		self error: 'Expected a type for the function return type.'.
	].

	returnType := aReturnType value.
	self function