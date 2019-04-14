Class {
	#name : #MbndSlovimCompilationTarget,
	#superclass : #MbndAbstractCompilationTarget,
	#instVars : [
		'slvmCompilationTarget'
	],
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #initialization }
MbndSlovimCompilationTarget >> initialize [
	super initialize.
	self initializeTypeSystem.
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget [
	^ slvmCompilationTarget
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget: anObject [
	slvmCompilationTarget := anObject
]
