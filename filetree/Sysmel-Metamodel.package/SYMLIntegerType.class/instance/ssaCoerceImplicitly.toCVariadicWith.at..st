coercion
ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition
	self size >= 4 ifTrue: [ ^ value ].
	signed ifTrue: [
		^ builder signExtend: value target: builder compilationTarget
	] ifFalse: [ 
		^ builder zeroExtend: value target: builder compilationTarget
	]