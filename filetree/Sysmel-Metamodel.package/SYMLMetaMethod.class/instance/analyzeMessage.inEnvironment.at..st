meta methods
analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	^ messageNode copy
		metaMethod: self;
		valueType: anEnvironment compilationTarget voidType;
		yourself