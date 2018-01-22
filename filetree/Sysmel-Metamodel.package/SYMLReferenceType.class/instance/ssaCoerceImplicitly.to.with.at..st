coercion
ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
	| cleanReferenced |
	cleanReferenced := referenced cleanType.
	cleanReferenced == targetType ifTrue: [
		cleanReferenced isFunctionType ifTrue: [ ^ value ].
		^ builder load: value
	].
	
	^ super ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition