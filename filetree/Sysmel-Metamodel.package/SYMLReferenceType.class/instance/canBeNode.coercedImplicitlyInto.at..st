testing
canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	^ referenced canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition