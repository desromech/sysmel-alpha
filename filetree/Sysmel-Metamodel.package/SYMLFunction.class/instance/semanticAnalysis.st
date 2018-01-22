semantic analysis
semanticAnalysis
	| scope argument |
	(definition isNil or: [hasSemanticAnalysis]) ifTrue: [ ^ self ].

	scope := (SYMLFunctionScope parent: definitionEnvironment) function: self.
	scope := SYMLLexicalScope parent: scope.
	
	arguments := functionType arguments collectWithIndex: [ :argumentType :index |
		argument := SYMLFunctionArgument new
			name: (argumentNames at: index);
			type: argumentType;
			node: (argumentNodes at: index);
			yourself.
		scope lookSymbol: argument name ifPresent: [:existent |
			self error: 'Duplicated argument name {1}.' format:  { argument name } at:  argument node
		] ifAbsentPut: [ argument ].
		argument
	].

	hasSemanticAnalysis := true.
	definition := definition semanticAnalysisInEnvironment: scope