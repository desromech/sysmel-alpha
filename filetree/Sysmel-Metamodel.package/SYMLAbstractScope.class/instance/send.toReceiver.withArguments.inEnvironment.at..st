meta methods
send: selector toReceiver: aReceiver withArguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	| metaMethod |
	metaMethod := self findRecursivelyMetaMethodForSelector: selector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNil: [
		self error: 'Failed to find meta method {1}.' format: {selector printString} at: aSourcePosition
	].

	^ metaMethod evaluateWithSelector: selector withReceiver: aReceiver withArguments: theArguments inEnvironment: anEnvironment at: aSourcePosition