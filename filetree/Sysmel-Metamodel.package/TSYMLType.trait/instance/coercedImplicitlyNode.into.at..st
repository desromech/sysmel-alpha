coercion
coercedImplicitlyNode: node into: targetType at: aSourcePosition
	(self canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ self ].
	
	self error: 'Cannot coerce implicitly a value of type {1} into {2}' format: {self asString . targetType asString} at: aSourcePosition