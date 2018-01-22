coercion
canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition
	| literalValue |
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	targetType isLiteralType ifFalse: [
		node ifNotNil: [ 
			literalValue := node value value.
			targetType isIntegerType ifTrue: [
				(targetType isUnsigned and: [literalValue < 0]) ifTrue: [ 
					^ false
				]
			]
		].
	].

	targetType isNumberType ifTrue: [ ^ true ].
	^ false