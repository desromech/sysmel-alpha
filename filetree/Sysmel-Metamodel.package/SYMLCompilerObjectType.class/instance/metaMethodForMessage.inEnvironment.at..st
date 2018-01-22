meta methods
metaMethodForMessage: messageNode  inEnvironment: anEnvironment at: aSourcePosition
	| receiverValue |
	receiverValue := messageNode receiver value value.
	^ self findMetaMethodForSelector: messageNode selector inImageReceiver: receiverValue at: aSourcePosition