coercion
coercedImplicitlyNode: node intoCVariadicAt: aSourcePosition
	(self canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition) ifTrue: [ ^ self ].
	
	self error: 'Cannot coerce implicitly a value of type {1} into C variadic argument' format: {self asString} at: aSourcePosition