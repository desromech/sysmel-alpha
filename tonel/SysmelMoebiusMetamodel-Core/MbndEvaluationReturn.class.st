Class {
	#name : #MbndEvaluationReturn,
	#superclass : #Exception,
	#instVars : [
		'targetReturnContext',
		'returnValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Exceptions'
}

{ #category : #accessing }
MbndEvaluationReturn >> returnValue [
	^ returnValue
]

{ #category : #accessing }
MbndEvaluationReturn >> returnValue: anObject [
	returnValue := anObject
]

{ #category : #accessing }
MbndEvaluationReturn >> targetReturnContext [
	^ targetReturnContext
]

{ #category : #accessing }
MbndEvaluationReturn >> targetReturnContext: anObject [
	targetReturnContext := anObject
]
