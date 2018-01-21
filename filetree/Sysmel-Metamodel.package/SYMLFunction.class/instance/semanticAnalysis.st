semantic analysis
semanticAnalysis
	| scope |
	(definition isNil or: [hasSemanticAnalysis]) ifTrue: [ ^ self ].
	
	hasSemanticAnalysis := true.
	scope := (SYMLFunctionScope parent: definitionEnvironment) function: self.
	definition := definition semanticAnalysisInEnvironment: scope