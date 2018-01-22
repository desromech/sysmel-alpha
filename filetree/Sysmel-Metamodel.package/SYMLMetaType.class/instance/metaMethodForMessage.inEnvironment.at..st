meta methods
metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	^ self findMetaMethodForSelector: messageNode selector inImageReceiver: instanceType value at: aSourcePosition