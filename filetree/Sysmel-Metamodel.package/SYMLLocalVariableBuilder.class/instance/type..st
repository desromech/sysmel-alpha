accessing
type: aType
	<compileTime>
	aType type isMetaType ifFalse: [ 
		self error: 'Expected a type for the local variable "{1}".' format: { name }
	].

	type := aType value