Class {
	#name : #MbndAstEvaluator,
	#superclass : #MbndAstVisitor,
	#instVars : [
		'scope'
	],
	#category : #'MoebiusBandMetamodel-Core-Evaluation'
}

{ #category : #accessing }
MbndAstEvaluator >> scope [
	^ scope
]

{ #category : #accessing }
MbndAstEvaluator >> scope: anObject [
	scope := anObject
]

{ #category : #visiting }
MbndAstEvaluator >> visitLiteralValueNode: node [
	^ node evaluateMbndValue
]
