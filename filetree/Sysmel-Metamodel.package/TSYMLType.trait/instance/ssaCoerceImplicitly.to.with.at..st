coercion
ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
	self == targetType ifTrue: [ ^ value ].
	self cleanType == targetType ifTrue: [ ^ value ]. "const -> non-const copy"
	
	self error: 'Unimplemented coercion from {1} to {2}.' format: { self asString . targetType asString } at: aSourcePosition