testing
canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	^ false