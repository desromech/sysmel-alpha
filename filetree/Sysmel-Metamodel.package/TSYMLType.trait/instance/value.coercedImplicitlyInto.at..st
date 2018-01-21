coercion
value: aValue coercedImplicitlyInto: targetType at: aSourcePosition
	targetType == self ifTrue: [ ^ aValue ].
	self error: 'Cannot coerce value of type {1} into type {2}' format: { self asString . targetType } at: aSourcePosition