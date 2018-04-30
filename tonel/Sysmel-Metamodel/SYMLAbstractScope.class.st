Class {
	#name : #SYMLAbstractScope,
	#superclass : #SYMLObject,
	#instVars : [
		'parent'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLAbstractScope class >> parent: aParent [
	^ self new parent: aParent; yourself
]

{ #category : #adding }
SYMLAbstractScope >> addFieldVariable: field at: aPosition [
	parent ifNotNil: [ ^ parent addFieldVariable: field at: aPosition ].
	self error: 'Cannot add field {1} at this scope.' format: { field name } at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> apsgBuilder [
	^ SYMLAPSGBuilder new environment: self
	
]

{ #category : #accessing }
SYMLAbstractScope >> compilationTarget [
	^ parent compilationTarget
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> definitionProgramEntity [
	^ parent definitionProgramEntity
]

{ #category : #testing }
SYMLAbstractScope >> isImmediateEnvironment [
	^ parent ifNotNil: [ parent isImmediateEnvironment ] ifNil: [ ^ true ]
]

{ #category : #testing }
SYMLAbstractScope >> isTemplateInstance [
	^ parent ifNotNil: [ parent isTemplateInstance ] ifNil: [ false ]
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> lookMetaMethodSelector: selector [
	self usedNamespacesDo: [ :namespace |
		(namespace lookMetaMethodSelector: selector) ifNotNil: [ :result | ^ result ].
	].
	parent ifNotNil: [ ^ parent lookMetaMethodSelector: selector ].
	^ nil
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	^ nil
	
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> lookSymbolRecursively: symbol ifAbsent: ifAbsentBlock [
	self lookSymbol: symbol ifPresent: [ :existent | ^ existent ].
	self usedNamespacesDo: [ :namespace |
		namespace lookSymbol: symbol ifPresent: [ :existent | ^ existent ].
	].

	parent ifNil: [ ifAbsentBlock value ].
	^ parent lookSymbolRecursively: symbol ifAbsent: ifAbsentBlock
]

{ #category : #'instance creation' }
SYMLAbstractScope >> newLexicalScope [
	^ SYMLLexicalScope parent: self
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
SYMLAbstractScope >> receiverType [
	parent ifNotNil: [ ^ parent ].
	^ self compilationTarget voidType
]

{ #category : #accessing }
SYMLAbstractScope >> returnType [
	parent ifNotNil: [ ^ parent returnType ].
	^ self compilationTarget dynamicObjectType
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> semanticAnalyzeMessage: message at: aPosition [
	"Support global meta methods."
	message receiver ifNil: [ 
		(self lookMetaMethodSelector: message selector) ifNil: [ 
			self error: 'Failed to find meta-method {1}.' format: { message selector printString } at: aPosition
		] ifNotNil: [ :metaMethod |
			^ metaMethod semanticAnalyzeMessage: message inEnvironment: self at: aPosition
		]
	].

	"Send into the meta objects."
	message receiver isMetaObjectInstance ifTrue: [
		^ message receiver metaObject semanticAnalyzeMessageToYou: message inEnvironment: self at: aPosition
	].

	"Analyze the receiver"
	message isReceiverAnalyzed ifFalse: [ 
		^ (message analyzeReceiverInEnvironment: self) semanticAnalysisInEnvironment: self
	].

	"Ask the receiver type to analyze the message"
	^ message receiver type semanticAnalyzeMessage: message inEnvironment: self at: aPosition
]

{ #category : #enumerating }
SYMLAbstractScope >> usedNamespacesDo: aBlock [
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> wrapAPSGNode: aNode [
	^ aNode sysmelValueWithType: self compilationTarget apsgNodeType inEnvironment: self
]
