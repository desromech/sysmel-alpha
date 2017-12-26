accessing
functionType
	functionType ifNil: [ self buildFunctionType ].
	^ functionType