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

{ #category : #accessing }
SYMLAbstractScope >> compilationTarget [
	^ parent compilationTarget
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> definitionProgramEntity [
	^ parent definitionProgramEntity
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	^ nil
	
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> lookSymbolRecursively: symbol ifAbsent: ifAbsentBlock [
	self lookSymbol: symbol ifPresent: [ :existent | ^ existent ].
	parent ifNil: [ ifAbsentBlock value ].
	^ parent lookSymbolRecursively: symbol ifAbsent: ifAbsentBlock
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
SYMLAbstractScope >> semanticAnalyzeMessage: message at: aPosition [
	"TODO: Support global meta methods."

	"Send into the meta objects."
	message receiver isMetaObjectInstance ifTrue: [
		^ message receiver metaObject semanticAnalyzeMessageToYou: message inEnvironment: self at: aPosition
	].

	"Analyze the receiver"
	message isReceiverAnalyzed ifFalse: [ 
		^ (message analyzeReceiverInEnvironment: self) semanticAnalysisInEnvironment: self
	].
	
	self halt
]

{ #category : #'as yet unclassified' }
SYMLAbstractScope >> wrapAPSGNode: aNode [
	^ aNode sysmelValueWithType: self compilationTarget apsgNodeType inEnvironment: self
]
