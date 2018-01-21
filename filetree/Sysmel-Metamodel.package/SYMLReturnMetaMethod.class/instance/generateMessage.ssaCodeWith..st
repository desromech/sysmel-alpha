meta methods
generateMessage: messageNode ssaCodeWith: builder
	| value valueNode valueType returnType |
	valueNode := messageNode arguments first.
	valueType := valueNode type.
	returnType := messageNode coercionType.
	value := valueType ssaCoerceImplicitly: (valueNode generateSSACodeWith: builder) to: returnType with: builder at: messageNode.
	^ returnType isVoidType ifTrue: [ 
		builder returnVoid
	] ifFalse: [
		builder return: value
	]