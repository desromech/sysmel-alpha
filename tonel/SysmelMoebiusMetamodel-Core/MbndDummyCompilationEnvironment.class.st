Class {
	#name : #MbndDummyCompilationEnvironment,
	#superclass : #Object,
	#instVars : [
		'dummyModule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

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
