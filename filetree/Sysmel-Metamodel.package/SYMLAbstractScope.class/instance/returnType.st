accessing
returnType
	parent ifNotNil: [ ^ parent returnType ].
	^ self compilationTarget voidType