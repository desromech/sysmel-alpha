converting
asNodeForTupleElementIn: anEnvironment
	value type isCompilerObjectType ifTrue: [ ^ value value convertNodeForTupleElement: self inEnvironment: anEnvironment ].
	^ self