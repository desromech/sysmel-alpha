meta methods
metaMethodForSelector: aSelector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	| receiverValue |
	receiverValue := aReceiver value value.
	^ self findMetaMethodForSelector: aSelector inImageReceiver: receiverValue at: aSourcePosition