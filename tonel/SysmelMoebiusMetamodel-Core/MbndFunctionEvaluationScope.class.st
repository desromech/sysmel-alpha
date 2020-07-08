Class {
	#name : #MbndFunctionEvaluationScope,
	#superclass : #MbndFunctionScope,
	#instVars : [
		'evaluationSourcePosition'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndFunctionEvaluationScope >> evaluationSourcePosition [
	^ evaluationSourcePosition
]

{ #category : #accessing }
MbndFunctionEvaluationScope >> evaluationSourcePosition: anObject [
	evaluationSourcePosition := anObject
]

{ #category : #accessing }
MbndFunctionEvaluationScope >> validSourcePosition [
	^ evaluationSourcePosition ifNil: [ programEntity validSourcePosition ]
]
