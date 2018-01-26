coercion
canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition
	| characterType |
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	(targetType isPointerType and: [ targetType pointed isConstantType ]) ifTrue: [ 
		characterType := targetType pointed cleanType.
		(characterType isIntegerType and: [characterType size = 1]) ifTrue: [ ^ true ].
	].

	^ false