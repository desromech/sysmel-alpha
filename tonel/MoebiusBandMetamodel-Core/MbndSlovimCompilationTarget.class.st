Class {
	#name : #MbndSlovimCompilationTarget,
	#superclass : #MbndAbstractCompilationTarget,
	#instVars : [
		'slvmCompilationTarget'
	],
	#category : #'MoebiusBandMetamodel-Core-CompilationTarget'
}

{ #category : #initialization }
MbndSlovimCompilationTarget >> initialize [
	super initialize.
	self initializeBasicTypes.
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget [
	^ slvmCompilationTarget
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget: anObject [
	slvmCompilationTarget := anObject
]
