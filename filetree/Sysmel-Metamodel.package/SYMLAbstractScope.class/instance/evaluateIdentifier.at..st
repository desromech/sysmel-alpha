variables
evaluateIdentifier: identifier at: position
	| binding |
	binding := self lookSymbolRecursively: identifier ifAbsent: [
		self error: 'Failed to find identifier {1}.' format: { identifier } at: position
	].

	^ binding evaluateReferenceAt: position