coercion
arithmeticCoerceWith: other
	self == other ifTrue: [ ^ self ].
	^ nil