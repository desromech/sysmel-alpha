accessing
fileName
	^ collection ifNil: ['generated'] ifNotNil: [collection isString ifTrue: [collection] ifFalse: [ collection name]]