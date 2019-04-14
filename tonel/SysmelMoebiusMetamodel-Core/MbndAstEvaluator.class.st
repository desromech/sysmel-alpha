Class {
	#name : #MbndAstEvaluator,
	#superclass : #MbndAstVisitor,
	#instVars : [
		'module',
		'scope'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Evaluation'
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
MbndAstEvaluator >> visitReturnStatementNode: node [
	| result |
	result := self visitNode: node expression.
	^ MbndEvaluationReturn new
		returnValue: result;
		targetReturnContext: scope returnContextScope;
		signal
]

{ #category : #visiting }
MbndAstEvaluator >> visitSequenceNode: node [
	| result |
	node elements ifEmpty: [
		^ MbndValue value: nil type: node type
	].

	result := nil.
	node elements do: [ :element |
		result := self visitNode: element 
	].
	^ result
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnexpandedMessageSendNode: node [
	self compilerBugError: 'Macro that should have been expanded is not expanded' at: node
]
