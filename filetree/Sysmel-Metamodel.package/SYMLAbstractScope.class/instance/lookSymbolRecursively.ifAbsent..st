variables
lookSymbolRecursively: identifier ifAbsent: aBlock
	self lookSymbol: identifier ifPresent: [ :result |
		^ result
	].

	parent ifNotNil: [ ^ parent lookSymbolRecursively: identifier ifAbsent: aBlock ].
	^ aBlock value