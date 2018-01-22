coercion
ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition
	self size >= 8 ifTrue: [ ^ value ].
	^ builder floatingPointCast: value target: builder compilationTarget double