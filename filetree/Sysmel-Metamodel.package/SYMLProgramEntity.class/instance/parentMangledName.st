name mangling
parentMangledName
	^ parent ifNil: [ '_S' ] ifNotNil: [ parent mangledName ]