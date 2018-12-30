Class {
	#name : #SYMLAPSGAnalyzedBlockClosureNode,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'blockClosure'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGAnalyzedBlockClosureNode >> arguments [
	^ blockClosure arguments
]

{ #category : #accessing }
SYMLAPSGAnalyzedBlockClosureNode >> blockClosure [
	^ blockClosure
]

{ #category : #accessing }
SYMLAPSGAnalyzedBlockClosureNode >> blockClosure: anObject [
	blockClosure := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedBlockClosureNode >> evaluateTypeInEnvironment: anEnvironment [
	^ blockClosure type
]

{ #category : #testing }
SYMLAPSGAnalyzedBlockClosureNode >> isBlockClosure [
	<compileTime>
	^ true
]

{ #category : #accessing }
SYMLAPSGAnalyzedBlockClosureNode >> returnType [
	^ blockClosure returnType
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedBlockClosureNode >> semanticAnalysisInEnvironment: environment [
	^ self
]
