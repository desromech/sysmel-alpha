Class {
	#name : #SYMLObject,
	#superclass : #Object,
	#classVars : [
		'SelectorWhitelist'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #initialization }
SYMLObject class >> initialize [
	SelectorWhitelist := Set newFrom: #(yourself)
]

{ #category : #'as yet unclassified' }
SYMLObject >> __sysmel [
	^ SYMLProxy new __interpreterObject: self
]

{ #category : #'as yet unclassified' }
SYMLObject >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ SYMLAPSGMetaObjectInstance new
			position: identifier;
			metaObject: self;
			yourself
]

{ #category : #'as yet unclassified' }
SYMLObject >> analyzeAndEvaluateMessageToYou: message inEnvironment: environment at: aPosition [
	^ (self semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition) evaluateInEnvironment: environment
]

{ #category : #converting }
SYMLObject >> asAPSGNodeInEnvironment: newEnvironment at: aPosition [
	^ SYMLAPSGMetaObjectInstance new
			position: aPosition;
			metaObject: self;
			yourself
]

{ #category : #converting }
SYMLObject >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ aNode
]

{ #category : #converting }
SYMLObject >> convertNodeForTupleElement: aNode inEnvironment: anEnvironment [
	^ aNode
]

{ #category : #errors }
SYMLObject >> error: anErrorString at: aSourcePosition [
	^ SYMLSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: self;
		signal
]

{ #category : #errors }
SYMLObject >> error: anErrorString format: formatArguments [
	^ self error: (anErrorString format: formatArguments)
]

{ #category : #errors }
SYMLObject >> error: anErrorString format: formatArguments at: aSourcePosition [
	^ self error: (anErrorString format: formatArguments) at: aSourcePosition
]

{ #category : #'as yet unclassified' }
SYMLObject >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ anEnvironment compilationTarget compilerObjectType
]

{ #category : #testing }
SYMLObject >> hasIncompleteSemanticAnalysis [
	^ false
]

{ #category : #testing }
SYMLObject >> isAbstractFunction [
	^ false
]

{ #category : #testing }
SYMLObject >> isFieldVariable [
	^ false
]

{ #category : #testing }
SYMLObject >> isFunctionalValue [
	^ false
]

{ #category : #testing }
SYMLObject >> isMacroPatternGroup [
	^ false
]

{ #category : #testing }
SYMLObject >> isMetaBuilder [
	^ false
]

{ #category : #testing }
SYMLObject >> isMetaMethod [
	^ false
]

{ #category : #testing }
SYMLObject >> isMetaObject [
	^ false
]

{ #category : #testing }
SYMLObject >> isNamespace [
	^ false
]

{ #category : #testing }
SYMLObject >> isRecursiveValue [
	^ false
]

{ #category : #testing }
SYMLObject >> isSysmelIncompleteValue [
	^ self hasIncompleteSemanticAnalysis
]

{ #category : #testing }
SYMLObject >> isSysmelObject [
	^ true
]

{ #category : #testing }
SYMLObject >> isTemplate [
	^ false
]

{ #category : #testing }
SYMLObject >> isTemplateInstance [
	^ false
]

{ #category : #testing }
SYMLObject >> isType [
	^ false
]

{ #category : #'as yet unclassified' }
SYMLObject >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	^ self sendCompileTimeMessage: message inEnvironment: environment at: aPosition.
]

{ #category : #'accessing method dictionary' }
SYMLObject >> sendCompileTimeMessage: message inEnvironment: environment at: aPosition [
	| compiledMethod isLazy isRewrite arguments result allowIncomplete analyzedArguments |
	compiledMethod := self class lookupSelector: message selector.
	compiledMethod ifNil: [ 
		self error: 'Cannot send unexistent message {1} to compile time object {2}.' format: { message selector printString . self printString } at: aPosition
	].

	((compiledMethod hasPragmaNamed: #compileTime) or: [ SelectorWhitelist includes: message selector ]) ifFalse: [
		self error: 'Cannot send message {1} to compile time object {2}.' format: { message selector printString . self printString } at: aPosition
	].

	isLazy := compiledMethod hasPragmaNamed: #lazy.
	isRewrite := compiledMethod hasPragmaNamed: #rewrite.
	allowIncomplete := compiledMethod hasPragmaNamed: #allowIncomplete.
	
	arguments := isLazy ifTrue: [
		message arguments collect: [ :arg | SYMLLazyValue new node: arg; environment: environment ]
	] ifFalse: [
		analyzedArguments := message arguments collect: [ :arg | arg semanticAnalysisInEnvironment: environment ].
		analyzedArguments collect: [ :arg | (arg evaluateInEnvironment: environment) unwrapSysmelValue ]
	].

	(isLazy not and: [isRewrite not and: [allowIncomplete not ]]) ifTrue: [ 
		arguments detect: #isSysmelIncompleteValue ifFound: [
			^ SYMLSendToHost new semanticAnalyzeMessage: (message copy arguments: analyzedArguments) inEnvironment: environment at: aPosition
		].
	].

	result := self perform: message selector withArguments: arguments.
	result isSysmelObject ifTrue: [
		result hasIncompleteSemanticAnalysis ifTrue: [ ^ result ].
	].
	
	^ isRewrite ifTrue: [
		result
	] ifFalse: [
		result asAPSGNodeInEnvironment: environment at: message position
	]
]

{ #category : #'as yet unclassified' }
SYMLObject >> sysmelPerform: aSelector fallbackWith: fallbackBlock [
	^ self sysmelPerform: aSelector withArguments: #() fallbackWith: fallbackBlock
]

{ #category : #'as yet unclassified' }
SYMLObject >> sysmelPerform: aSelector withArguments: arguments fallbackWith: fallbackBlock [
	^ fallbackBlock value
]
