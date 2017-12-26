meta methods
findRecursivelyMetaMethodForSelector: selector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	| result |
	result := self metaMethodForSelector: selector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition.
	result ifNotNil: [ ^ result ].
	parent ifNotNil: [ ^ parent findRecursivelyMetaMethodForSelector: selector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition ].
	^ nil