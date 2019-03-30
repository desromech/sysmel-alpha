Class {
	#name : #MbndAstEvaluator,
	#superclass : #MbndAstVisitor,
	#instVars : [
		'module',
		'scope'
	],
	#category : #'MoebiusBandMetamodel-Core-Evaluation'
}

{ #category : #accessing }
MbndAstEvaluator >> module [
	^ module
]

{ #category : #accessing }
MbndAstEvaluator >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndAstEvaluator >> scope [
	^ scope
]

{ #category : #accessing }
MbndAstEvaluator >> scope: anObject [
	scope := anObject
]

{ #category : #visiting }
MbndAstEvaluator >> visitExpandedMessageSendNode: node [
	self assert: node type isNotNil.
	self halt
]

{ #category : #visiting }
MbndAstEvaluator >> visitLiteralValueNode: node [
	^ node evaluateMbndValue
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnexpandedMessageSendNode: node [
	self compilerBugError: 'Macro that should have been expanded is not expanded' at: node
]
