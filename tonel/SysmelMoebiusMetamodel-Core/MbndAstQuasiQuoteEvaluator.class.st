Class {
	#name : #MbndAstQuasiQuoteEvaluator,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'unquoteEvaluator'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Evaluation'
}

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> unquoteEvaluator [
	^ unquoteEvaluator
]

{ #category : #accessing }
MbndAstQuasiQuoteEvaluator >> unquoteEvaluator: anObject [
	unquoteEvaluator := anObject
]

{ #category : #visiting }
MbndAstQuasiQuoteEvaluator >> visitQuasiUnquoteNode: node [
	| result |
	result := unquoteEvaluator visitNode: node expression.
	self assert: result type isASTNodeType.
	^ result value
]
