coercion
canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition
	self == targetType ifTrue: [ ^ true ].
	^ false