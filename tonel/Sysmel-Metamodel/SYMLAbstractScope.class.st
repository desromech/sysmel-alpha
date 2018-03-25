Class {
	#name : #SYMLAbstractScope,
	#superclass : #Object,
	#instVars : [
		'parent',
		'compilationTarget'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #requirements }
SYMLAbstractScope class >> empty [
	^ self new
]

{ #category : #requirements }
SYMLAbstractScope class >> parent: aParent [
	^ self new parent: aParent; yourself
]

{ #category : #adding }
SYMLAbstractScope >> addSymbol: symbol withValue: symbolValue [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> apsgBuilder [
	^ SYMLAPSGBuilder new environment: self
]

{ #category : #accessing }
SYMLAbstractScope >> compilationTarget [
	^ compilationTarget ifNil: [compilationTarget := parent compilationTarget]
]

{ #category : #errors }
SYMLAbstractScope >> error: anErrorString at: aSourcePosition [
	^ SYMLSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: self;
		signal
]

{ #category : #errors }
SYMLAbstractScope >> error: formatString format: formatElements at: aSourcePosition [
	^ self error: (formatString format: formatElements) at: aSourcePosition
]

{ #category : #accessing }
SYMLAbstractScope >> findDefinitionProgramEntity [
	^ self findProgramEntityDefinitionScope programEntity
]

{ #category : #accessing }
SYMLAbstractScope >> findLocalDefinitionScope [
	^ self findLocalDefinitionScopeFrom: self
]

{ #category : #accessing }
SYMLAbstractScope >> findLocalDefinitionScopeFrom: startingPoint [
	^ parent findLocalDefinitionScopeFrom: startingPoint
]

{ #category : #accessing }
SYMLAbstractScope >> findProgramEntityDefinitionScope [
	^ self findProgramEntityDefinitionScopeFrom: self
]

{ #category : #accessing }
SYMLAbstractScope >> findProgramEntityDefinitionScopeFrom: startingPoint [
	^ parent findProgramEntityDefinitionScopeFrom: startingPoint
]

{ #category : #'meta methods' }
SYMLAbstractScope >> findRecursivelyMetaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| result |
	result := self metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition.
	result ifNotNil: [ ^ result ].
	parent ifNotNil: [ ^ parent findRecursivelyMetaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition ].
	^ nil
]

{ #category : #testing }
SYMLAbstractScope >> hasSupportForOverloadedFunctions [
	^ false
]

{ #category : #variables }
SYMLAbstractScope >> lookSymbol: identifier ifPresent: aBlock [
	^ nil
]

{ #category : #variables }
SYMLAbstractScope >> lookSymbolRecursively: identifier ifAbsent: aBlock [
	self lookSymbol: identifier ifPresent: [ :result |
		^ result
	].

	parent ifNotNil: [ ^ parent lookSymbolRecursively: identifier ifAbsent: aBlock ].
	^ aBlock value
]

{ #category : #'meta methods' }
SYMLAbstractScope >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ nil
]

{ #category : #accessing }
SYMLAbstractScope >> module [
	^ parent module
]

{ #category : #accessing }
SYMLAbstractScope >> parent [
	^ parent
]

{ #category : #accessing }
SYMLAbstractScope >> parent: anObject [
	parent := anObject
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> programEntity [
	parent ifNotNil: [ ^ parent programEntity ].
	^ nil
]

{ #category : #accessing }
SYMLAbstractScope >> returnType [
	parent ifNotNil: [ ^ parent returnType ].
	^ self compilationTarget voidType
]

{ #category : #'meta methods' }
SYMLAbstractScope >> semanticAnalyzeMessage: messageNode at: aSourcePosition [
	^ self semanticAnalyzeMessage: messageNode inEnvironment: self at: aSourcePosition
]

{ #category : #'meta methods' }
SYMLAbstractScope >> semanticAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| metaMethod |
	metaMethod := self findRecursivelyMetaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNil: [
		self error: 'Failed to find meta method {1}.' format: {messageNode selector printString} at: aSourcePosition
	].

	^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> wrapAPSGNode: aNode [
	^ aNode sysmelValueWithType: self compilationTarget apsgNodeType inEnvironment: self
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> wrapAPSGNodes: aCollectionOfNodes [
	| type |
	type := self compilationTarget apsgNodeType.
	^ aCollectionOfNodes collect: [:node | node sysmelValueWithType: type inEnvironment: self]
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> wrapASTNode: aNode [
	^ aNode sysmelValueWithType: self compilationTarget astNodeType inEnvironment: self
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> wrapASTNodes: aCollectionOfNodes [
	| type |
	type := self compilationTarget astNodeType.
	^ aCollectionOfNodes collect: [:node | node sysmelValueWithType: type  inEnvironment: self]
]
