coercion
ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
	| characterType |
	(targetType isPointerType and: [ targetType pointed isConstantType ]) ifTrue: [ 
		characterType := targetType pointed cleanType.
		(characterType isIntegerType and: [characterType size = 1]) ifTrue: [
			^ self ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition
		].
	].

	^ super ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition