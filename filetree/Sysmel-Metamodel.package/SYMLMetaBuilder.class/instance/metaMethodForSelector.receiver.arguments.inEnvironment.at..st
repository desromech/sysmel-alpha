meta methods
metaMethodForSelector: aSelector receiver: aReceiver arguments: theArguments inEnvironment: anEnvironment at: aSourcePosition
	| metaMethod |
	(aReceiver evaluateTypeInEnvironment: anEnvironment) ~~ self ifTrue: [ ^ nil ].
	
	metaMethod := self findMetaMethodForSelector: aSelector inImageReceiver: self at: aSourcePosition.
	metaMethod ifNotNil: [ ^ metaMethod ].
	
	theArguments ifNotEmpty: [ ^ nil ].
	
	^ self