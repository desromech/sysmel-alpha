meta methods
metaMethodForMessage: messageNode  inEnvironment: anEnvironment at: aSourcePosition
	| receiverValue |
	receiverValue := (messageNode receiver evaluateInEnvironment: anEnvironment) value value.
	^ self findMetaMethodForSelector: messageNode selector inImageReceiver: receiverValue at: aSourcePosition