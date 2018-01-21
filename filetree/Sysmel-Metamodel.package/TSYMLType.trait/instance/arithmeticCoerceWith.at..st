coercion
arithmeticCoerceWith: other at: aSourcePosition
	| result |
	result := self arithmeticCoerceWith: other.
	result ifNil: [ self error: 'Failed to perform arithmetic coercion with type {1} and {2}.' format: { self asString . other asString } at: aSourcePosition ].
	^ result