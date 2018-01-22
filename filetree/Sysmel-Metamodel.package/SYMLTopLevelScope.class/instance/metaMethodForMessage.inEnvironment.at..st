accessing
metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	messageNode receiver ifNil: [
		^ implicitContextMetaMethods at: messageNode selector ifAbsent: [ nil ]
	] ifNotNil: [ 
		genericMetaMethods at: messageNode selector ifPresent: [ :metaMethod |
			(metaMethod canAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition) ifTrue: [ 
				^ metaMethod
			]
		].
	].
	
	"Lets try to use the receiver meta method"
	^ fallbackToReceiver