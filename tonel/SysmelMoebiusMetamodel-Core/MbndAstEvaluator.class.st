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
	| receiver arguments |
	self assert: node type isNotNil.
	self assert: node method isNotNil.
	receiver := node receiver ifNotNil: [ self visitNode: node receiver ].
	arguments := self visitNodesAndCollect: node arguments.
	^ node method evaluateWithReceiver: receiver arguments: arguments withEvaluator: self at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitLiteralValueNode: node [
	^ node evaluateMbndValue
]

{ #category : #visiting }
MbndAstEvaluator >> visitLocalVariableDefinitionNode: node [
	self assert: node binding isNotNil.
	self assert: node initialValue isNotNil.
	^ node binding evaluateLocalDefinition: node withEvaluator: self

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

{ #category : #visiting }
MbndAstEvaluator >> visitVariableReferenceNode: node [
	self assert: node binding isNotNil.
	^ node binding asCompileTimeValueReferenceOfType: node type withEvaluator: self at: node
]
