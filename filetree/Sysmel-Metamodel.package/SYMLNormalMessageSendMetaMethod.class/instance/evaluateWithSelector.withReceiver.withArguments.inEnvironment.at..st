as yet unclassified
evaluateWithSelector: aSelector withReceiver: aReceiver withArguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	^ (aReceiver value perform: aSelector withArguments: (theArguments collect: [:arg |
		arg evaluateInEnvironment: anEnvironment
	])) asSysmelValueInEnvironment: anEnvironment