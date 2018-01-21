accessing
semanticAnalysisInEnvironment: anEnvironment
	| binding |
	binding := anEnvironment lookSymbolRecursively: value ifAbsent: [
		self error: 'Failed to find identifier {1}.' format: { value } at: position
	].

	^ SYMLAPSGIdentifierWithBinding new
		position: self;
		value: value;
		binding: binding;
		yourself