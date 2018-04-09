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

{ #category : #testing }
SYMLObject >> hasIncompleteSemanticAnalysis [
	^ false
]

{ #category : #testing }
SYMLObject >> isAbstractFunction [
	^ false
]

{ #category : #testing }
SYMLObject >> isIncompleteValue [
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
SYMLObject >> isSysmelObject [
	^ true
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
	| compiledMethod isLazy isRewrite arguments result |
	compiledMethod := self class lookupSelector: message selector.
	compiledMethod ifNil: [ 
		self error: 'Cannot send unexistent message {1} to compile time object {2}.' format: { message selector printString . self printString } at: aPosition
	].

	((compiledMethod hasPragmaNamed: #compileTime) or: [ SelectorWhitelist includes: message selector ]) ifFalse: [
		self error: 'Cannot send message {1} to compile time object {2}.' format: { message selector printString . self printString } at: aPosition
	].

	isLazy := compiledMethod hasPragmaNamed: #lazy.
	isRewrite := compiledMethod hasPragmaNamed: #rewrite.
	
	arguments := isLazy ifTrue: [
		message arguments collect: [ :arg | SYMLLazyValue new node: arg; environment: environment ]
	] ifFalse: [
		message arguments collect: [ :arg | (arg analyzeAndEvaluateInEnvironment: environment) unwrapSysmelValue ]
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
