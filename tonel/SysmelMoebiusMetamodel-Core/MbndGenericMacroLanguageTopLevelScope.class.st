"
I am a generic macro language top-level scope. I add some top-level macros.

I introduce the following core control flow top-level macros:

- return:
- if:then:
- if:then:else:
- while:do:
- do:while:

I introduce the following synthesized control-flow macros:
- until:do:
- do:until:

"
Class {
	#name : #MbndGenericMacroLanguageTopLevelScope,
	#superclass : #MbndGenericLanguageTopLevelScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndGenericMacroLanguageTopLevelScope >> addControlFlowMacros [
	self
		onMacroSelector: #return: do: [ :node :builder |
			(builder return: node arguments first)
				position: node
		];
	
		onMacroSelector: #if:then: do: [ :node :builder |
			(builder if: node arguments first trueValue: node arguments second falseValue: nil)
				position: node
		];
		onMacroSelector: #if:then:else: do: [ :node :builder |
			(builder if: node arguments first trueValue: node arguments second falseValue: node arguments third)
				position: node
		];
	
		onMacroSelector: #while:do: do: [ :node :builder |
			(builder while: node arguments first do: node arguments second)
				position: node
		];
		onMacroSelector: #while:do:continueWith: do: [ :node :builder |
			(builder while: node arguments first do: node arguments second continueWith: node arguments third)
				position: node
		];
		onMacroSelector: #do:while: do: [ :node :builder |
			(builder do: node arguments first while: node arguments second)
				position: node
		];
		onMacroSelector: #until:do: do: [ :node :builder |
			(builder while:
				((builder unexpandedSend: (builder literalSymbol: #not) to: node arguments first withArguments: #())
					position: node arguments first)
				do: node arguments second)
				position: node
		];
		onMacroSelector: #until:do:continueWith: do: [ :node :builder |
			(builder while:
				((builder unexpandedSend: (builder literalSymbol: #not) to: node arguments first withArguments: #())
					position: node arguments first)
				do: node arguments second
				continueWith: node arguments third)
				position: node
		];
		onMacroSelector: #do:until: do: [ :node :builder |
			(builder do: node arguments first
				while: ((node unexpandedSend: #not to: node arguments second withArguments: #())
					position: node arguments second))
				position: node
		];
		onMacroSelector: #of:selectCase: do: [ :node :builder |
			(builder casesOf: node arguments first cases: node arguments second)
				position: node
		];
		onMacroSelector: #try:catch:doing: do: [ :node :builder |
			(builder exceptionLexicalScope: node arguments first
				catchExpressions: {
					(builder exceptionCatch: node arguments second doing: node arguments third)
						position: node
				} cleanUpActions: #())
				position: node
		];
		onMacroSelector: #try:finally: do: [ :node :builder |
			(builder exceptionLexicalScope: node arguments first
				catchExpressions: #() cleanUpActions: { node arguments second lexicallyScoped })
				position: node
		];
		onMacroSelector: #try:catch:doing:finally: do: [ :node :builder |
			(builder exceptionLexicalScope: node arguments first
				catchExpressions: {
					(builder exceptionCatch: node arguments second doing: node arguments third)
						position: node
				} cleanUpActions: { node arguments fourth lexicallyScoped})
				position: node
		].
]

{ #category : #initialization }
MbndGenericMacroLanguageTopLevelScope >> addModuleMacros [
	self
		onMacroSelector: #loadFileOnce: do: [ :node :builder :analyzer|
			| fileName sourceFileReference|
			fileName := analyzer evaluateCompileTimeExpression: node arguments first.
			fileName type isLiteralStringType ifFalse: [
				analyzer error: 'Expected the path for a file name to evaluate.' at: node.
			].
		
			sourceFileReference := analyzer scope workingDirectory resolve: fileName value asFileReference.
			sourceFileReference exists ifFalse: [ 
				analyzer error: 'Cannot load unexistent file {1}.' format: { sourceFileReference fullName } at: node.
			].
		
			analyzer module evaluateFileNamedOnce: sourceFileReference.
			builder literalVoid
		];
		onMacroSelector: #loadFile: do: [ :node :builder :analyzer |
			| fileName sourceFileReference result |
			fileName := analyzer evaluateCompileTimeExpression: node arguments first.
			fileName type isLiteralStringType ifFalse: [
				analyzer error: 'Expected the path for a file name to evaluate.' at: node.
			].
		
			sourceFileReference := analyzer scope workingDirectory resolve: fileName value asFileReference.
			sourceFileReference exists ifFalse: [ 
				analyzer error: 'Cannot load unexistent file {1}.' format: { sourceFileReference fullName } at: node.
			].
		
			result := analyzer module evaluateFileNamed: sourceFileReference.

			self halt
		]

]

{ #category : #initialization }
MbndGenericMacroLanguageTopLevelScope >> addNamespaceMacros [
	self
		onMacroSelector: #useNamespace: do: [ :node :builder :analyzer |
			| usedEntity |
			usedEntity := analyzer evaluateCompileTimeExpression: node arguments first.
			usedEntity type isNamespaceType ifFalse: [
				self error: 'Cannot use and export program entity.' at: node.
			].

			analyzer scope useNamespace: usedEntity value.
			builder literalVoid
		];
		onMacroSelector: #useNamespaceAndExportSymbols: do: [ :node :builder :analyzer |
			| usedEntity |
			usedEntity := analyzer evaluateCompileTimeExpression: node arguments first.
			usedEntity type isNamespaceType ifFalse: [
				self error: 'Cannot use and export program entity.' at: node.
			].

			analyzer scope lookupProgramEntityForNewDefinitions
				ifNil: [ self error: 'Cannot use and export a namespace in this context.' at: node ]
				ifNotNil: [ :usageAndExportContext |
					usageAndExportContext useAndExportNamespace: usedEntity value
				].
			
			builder literalVoid
		].

]

{ #category : #initialization }
MbndGenericMacroLanguageTopLevelScope >> addTargetSpecificMacros [
	self
		onMacroSelector: #inlineAssembly:architecture:dialect:inputList:outputList:clobberList: do: [ :node :builder |
			(builder inlineAssembly: node arguments first
				architecture: node arguments second dialect: node arguments third
				inputList: node arguments fourth outputList: node arguments fifth
				clobberList: node arguments sixth)
				position: node;
				yourself
		];
		onMacroSelector: #inlineAssembly:architecture:dialect: do: [ :node :builder |
			(builder inlineAssembly: node arguments first
				architecture: node arguments second dialect: node arguments third
				inputList: #() outputList: #() clobberList: #())
				position: node;
				yourself
		];
		onMacroSelector: #volatileInlineAssembly:architecture:dialect:inputList:outputList:clobberList: do: [ :node :builder |
			(builder inlineAssembly: node arguments first
				architecture: node arguments second dialect: node arguments third
				inputList: node arguments fourth outputList: node arguments fifth
				clobberList: node arguments sixth)
				position: node;
				volatile;
				yourself
		];
		onMacroSelector: #volatileInlineAssembly:architecture:dialect: do: [ :node :builder |
			(builder inlineAssembly: node arguments first
				architecture: node arguments second dialect: node arguments third
				inputList: #() outputList: #() clobberList: #())
				position: node;
				volatile;
				yourself
		]
]

{ #category : #initialization }
MbndGenericMacroLanguageTopLevelScope >> addTopLevelMacros [
	super addTopLevelMacros.
	
	self
		addModuleMacros;
		addNamespaceMacros;
		addControlFlowMacros;
		addTargetSpecificMacros

]
