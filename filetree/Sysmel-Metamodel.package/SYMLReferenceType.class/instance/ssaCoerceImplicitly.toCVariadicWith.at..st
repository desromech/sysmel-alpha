coercion
ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition
	| cleanReferenced |
	cleanReferenced := referenced cleanType.
	cleanReferenced isFunctionType ifTrue: [ ^ value ].
	^ builder load: value