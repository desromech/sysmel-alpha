meta methods
metaMethodForSelector: aSelector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	^ self findMetaMethodForSelector: aSelector inImageReceiver: aReceiver value at: aSourcePosition