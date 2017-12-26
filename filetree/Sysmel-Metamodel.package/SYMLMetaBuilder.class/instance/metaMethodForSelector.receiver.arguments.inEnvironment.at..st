meta methods
metaMethodForSelector: aSelector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	| metaMethod |
	metaMethod := self findMetaMethodForSelector: aSelector inImageReceiver: aReceiver value at: aSourcePosition.
	metaMethod ifNotNil: [ ^ metaMethod ].
	
	theArguments ifNotEmpty: [ ^ nil ].
	
	^ self