Class {
	#name : #MbndDummyCompilationEnvironment,
	#superclass : #Object,
	#instVars : [
		'dummyModule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'semantic analysis' }
MbndDummyCompilationEnvironment >> analyzeReferenceNode: referenceNode with: analyzer [
	^ (self asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
		position: referenceNode;
		yourself
]

{ #category : #accessing }
MbndDummyCompilationEnvironment >> compilationTarget [
	^ dummyModule compilationTarget
]

{ #category : #accessing }
MbndDummyCompilationEnvironment >> currentModule [
	^ dummyModule
]

{ #category : #accessing }
MbndDummyCompilationEnvironment >> dummyModule [
	^ dummyModule
]

{ #category : #accessing }
MbndDummyCompilationEnvironment >> dummyModule: anObject [
	dummyModule := anObject
]
