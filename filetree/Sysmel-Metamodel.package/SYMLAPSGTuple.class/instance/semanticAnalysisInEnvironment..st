meta evaluation
semanticAnalysisInEnvironment: anEnvironment
	| result type |
	result := SYMLAPSGTupleWithType new elements: (elements collect: [:el | (el semanticAnalysisInEnvironment: anEnvironment) asNodeForTupleElementIn: anEnvironment  ]).
	type := anEnvironment compilationTarget tuple: (result elements collect: [ :el | el evaluateTypeInEnvironment: anEnvironment ]).
	result type: type.
	^ result