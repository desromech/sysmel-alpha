Class {
	#name : #SYMLBlockClosureAnalysisScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'blockClosure'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLBlockClosureAnalysisScope >> blockClosure [
	blockClosure
]

{ #category : #accessing }
SYMLBlockClosureAnalysisScope >> blockClosure: anObject [
	blockClosure := anObject
]

{ #category : #'as yet unclassified' }
SYMLBlockClosureAnalysisScope >> definitionProgramEntity [
	^ blockClosure
]

{ #category : #'as yet unclassified' }
SYMLBlockClosureAnalysisScope >> isImmediateEnvironment [
	^ false
]

{ #category : #'as yet unclassified' }
SYMLBlockClosureAnalysisScope >> newLexicalScope [
	^ (self class parent: self)
		blockClosure: blockClosure;
		yourself
]
