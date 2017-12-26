accessing
compilationTarget
	^ compilationTarget ifNil: [compilationTarget := parent compilationTarget]