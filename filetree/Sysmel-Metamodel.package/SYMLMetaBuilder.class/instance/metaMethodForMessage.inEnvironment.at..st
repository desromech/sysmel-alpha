meta methods
metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	| metaMethod |
	(messageNode receiver evaluateTypeInEnvironment: anEnvironment) ~~ self ifTrue: [ ^ nil ].
	
	metaMethod := self findMetaMethodForSelector: messageNode selector inImageReceiver: self at: aSourcePosition.
	metaMethod ifNotNil: [ ^ metaMethod ].
	
	messageNode arguments ifNotEmpty: [ ^ nil ].
	
	^ self