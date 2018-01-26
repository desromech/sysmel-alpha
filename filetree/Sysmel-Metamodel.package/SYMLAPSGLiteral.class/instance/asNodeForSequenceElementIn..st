converting
asNodeForSequenceElementIn: anEnvironment
	value type isCompilerObjectType ifTrue: [ ^ value value convertNodeForSequenceElement: self inEnvironment: anEnvironment ].
	^ self