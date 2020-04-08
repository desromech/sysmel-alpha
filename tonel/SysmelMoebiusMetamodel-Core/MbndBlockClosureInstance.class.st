Class {
	#name : #MbndBlockClosureInstance,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'closureProgramEntity',
		'capturedValues'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #accessing }
MbndBlockClosureInstance >> capturedValues [
	^ capturedValues
]

{ #category : #accessing }
MbndBlockClosureInstance >> capturedValues: anObject [
	capturedValues := anObject
]

{ #category : #accessing }
MbndBlockClosureInstance >> closureProgramEntity [
	^ closureProgramEntity
]

{ #category : #accessing }
MbndBlockClosureInstance >> closureProgramEntity: anObject [
	closureProgramEntity := anObject
]

{ #category : #evaluation }
MbndBlockClosureInstance >> evaluateApplicationWithArguments: argumentValues withEvaluator: evaluator at: position [
	^ closureProgramEntity evaluateApplicationWithCapturedValues: capturedValues arguments: argumentValues withEvaluator: evaluator at: position
]

{ #category : #accessing }
MbndBlockClosureInstance >> type [
	^ closureProgramEntity type
]

{ #category : #accessing }
MbndBlockClosureInstance >> valueWithArguments: arguments [
	| convertedArguments |
	convertedArguments := arguments collect: [ :each | each asMoebiusValueWithTarget: self compilationTarget ].
	^ self evaluateApplicationWithArguments: convertedArguments withEvaluator: self createEvaluator at: MbndSourcePosition empty
]
