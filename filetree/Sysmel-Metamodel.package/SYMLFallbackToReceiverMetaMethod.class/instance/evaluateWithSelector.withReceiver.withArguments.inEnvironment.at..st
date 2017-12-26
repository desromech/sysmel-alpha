meta methods
evaluateWithSelector: aSelector withReceiver: aReceiver withArguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	| receiverType metaMethod arguments |
	receiverType := aReceiver type.
	receiverType isAPSGNode ifTrue: [
		^ anEnvironment send: aSelector toReceiver: (receiverType evaluateValue: aReceiver inEnvironment: anEnvironment) withArguments: theArguments at: aSourcePosition
	].

	"Try evaluating with just the AST nodes."
	arguments := theArguments.
	metaMethod := receiverType metaMethodForSelector: aSelector receiver: aReceiver arguments: arguments inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNotNil: [
		^ metaMethod evaluateWithSelector: aSelector withReceiver: aReceiver withArguments: arguments inEnvironment: anEnvironment at: aSourcePosition
	].

	"Now try by evaluating the arguments"
	arguments := theArguments collect: [ :arg |
		arg evaluateInEnvironment: anEnvironment
	].
	
	metaMethod := receiverType metaMethodForSelector: aSelector receiver: aReceiver arguments: arguments inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNotNil: [
		^ metaMethod evaluateWithSelector: aSelector withReceiver: aReceiver withArguments: arguments inEnvironment: anEnvironment at: aSourcePosition
	].

	anEnvironment error: 'Failed to find a meta method for {1} >>> {2} ' format: { receiverType printString . aSelector } at: aSourcePosition