Class {
	#name : #MbndAstEvaluator,
	#superclass : #MbndAstVisitor,
	#instVars : [
		'module',
		'scope',
		'currentBreakContext',
		'currentContinueContext'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Evaluation'
}

{ #category : #'as yet unclassified' }
MbndAstEvaluator >> evaluateFunctionContent: ast [
	| returnContext |
	returnContext := self scope returnContextScope.
	
	[ 
		^ self visitNode: ast
	] on: MbndEvaluationReturn do: [ :e |
		e targetReturnContext == returnContext
			ifTrue: [ ^ e returnValue ]
			ifFalse: [ ^ e pass ]
	]
	
]

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
MbndAstEvaluator >> visitAssignmentNode: node [
	| value reference |
	value := self visitNode: node value.
	reference := self visitNode: node reference.
	
	reference value value: value.
	^ reference
]

{ #category : #visiting }
MbndAstEvaluator >> visitClassDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitConvertFromCompilerObjectCastNode: node [
	| result |
	result := (self visitNode: node expression) unwrapMbndValue.
	result := (node targetType legalizeLiteralValue: result).
	^ MbndValue value: result type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitConvertToASTNodeCastNode: node [
	| result resultNode |
	result := self visitNode: node expression.
	resultNode := result unwrapMbndValue.
	resultNode isMbndAstNode ifFalse: [ 
		resultNode := resultNode	asMoebiusLiteralValueNodeWithTarget: module compilationTarget.
	].

	^ MbndValue value: resultNode type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitConvertToCompilerObjectCastNode: node [
	| result |
	result := self visitNode: node expression.
	^ result copy
		type: node type;
		yourself
]

{ #category : #visiting }
MbndAstEvaluator >> visitExpandedHostMessageSendNode: node [
	| receiver selector arguments result |
	receiver := (self visitNode: node receiver) unwrapMbndValue.
	selector := (self visitNode: node selector) unwrapMbndValue.
	arguments := node arguments collect: [ :arg| (self visitNode: arg) unwrapMbndValue ].
	result := receiver perform: selector withArguments: arguments.
	^ MbndValue value: result type: node type
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
MbndAstEvaluator >> visitExplicitCastNode: node [
	self error: 'Cannot evaluate an unexpanded implicit cast.' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitFieldDefinitionNode: node [
	^ MbndValue value: nil type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitFunctionCallNode: node [
	| function arguments |
	self assert: node type isNotNil.
	function := self visitNode: node function.
	arguments := self visitNodesAndCollect: node arguments.
	^ function unwrapMbndValue evaluateApplicationWithArguments: arguments withEvaluator: self at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitFunctionDefinitionNode: node [
	^ self visitNode: node prototype
]

{ #category : #visiting }
MbndAstEvaluator >> visitFunctionPrototypeNode: node [
	self assert: node concreteMethod isNotNil.
	^ MbndValue value: node concreteMethod type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitGCClassDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitIfConditionNode: node [
	| condition result |
	condition := self visitNode: node condition.
	
	result := condition unwrapMbndValue ifTrue: [
		node trueValue
			ifNotNil: [ :expression | self visitNode: expression ]
			ifNil: [ node type defaultValue ]
	] ifFalse: [ 
		node falseValue
			ifNotNil: [ :expression | self visitNode: expression ]
			ifNil: [ node type defaultValue ]
	].

	^ node type isVoidType ifTrue: [
		node type defaultValue
	] ifFalse: [
		result
	]
]

{ #category : #visiting }
MbndAstEvaluator >> visitImplicitCastNode: node [
	self error: 'Cannot evaluate an unexpanded implicit cast.' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitLexicalScopeNode: node [
	^ self withScope: scope newLexicalScope do: [
		self visitNode: node expression
	]
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
MbndAstEvaluator >> visitMacroMessageDefinitionNode: node [
	^ node prototype
]

{ #category : #visiting }
MbndAstEvaluator >> visitMessageDefinitionNode: node [
	^ self visitNode: node prototype
]

{ #category : #visiting }
MbndAstEvaluator >> visitMessagePrototypeNode: node [
	self assert: node concreteMethod isNotNil.
	^ MbndValue value: node concreteMethod type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitMethodReferenceNode: node [
	self assert: node binding isNotNil.
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitQuasiQuoteNode: node [
	| result |
	result := MbndAstQuasiQuoteEvaluator new
		unquoteEvaluator: self;
		visitNode: node expression.
	self assert: result isMbndAstNode.
	^ MbndValue value: result type: node type.
]

{ #category : #visiting }
MbndAstEvaluator >> visitQuoteNode: node [
	^ MbndValue value: node expression type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitReferenceLoadNode: node [
	| reference |
	reference := self visitNode: node reference.
	^ reference value value
]

{ #category : #visiting }
MbndAstEvaluator >> visitReinterpretCastNode: node [
	self error: 'Cannot evaluate an unexpanded reinterpret cast.' at: node
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
MbndAstEvaluator >> visitStructureDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitTemplateDefinitionNode: node [
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTupleNode: node [
	| result |
	result := node elements collect: [ :el | (self visitNode: el) unwrapMbndValue ].
	^ MbndValue value: result type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitTypeDefinitionNode: node [
	^ MbndValue value: node binding type: node type
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnexpandedMessageSendNode: node [
	self compilerBugError: 'Macro that should have been expanded is not expanded' at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitUnionDefinitionNode: node [
	^ self visitTypeDefinitionNode: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitVariableReferenceNode: node [
	self assert: node binding isNotNil.
	^ node binding asCompileTimeValueReferenceOfType: node type withEvaluator: self at: node
]

{ #category : #visiting }
MbndAstEvaluator >> visitWhileLoopNode: node [
	| loopContext hasReceivedBreak |
	loopContext := Object new.
	
	hasReceivedBreak := false.
	[
		hasReceivedBreak not and: [
			node condition
				ifNil: [ true ]
				ifNotNil: [(self visitNode: node condition) unwrapMbndValue]]
	] whileTrue: [
		[
			self withBreakAndContinueContext: loopContext do: [
				node action ifNotNil: [ :action | self visitNode: action ]
			]
		] on: MbndBlockExitAction do: [ :e |
			e blockContext == loopContext ifFalse: [
				^ e pass.
			].
		
			hasReceivedBreak := e isBreakAction.
		].
	
		hasReceivedBreak ifFalse: [
			node continueAction ifNotNil: [ :action | self visitNode: action ]
		].
	].

	^ node type defaultValue
]

{ #category : #visiting }
MbndAstEvaluator >> withBreakAndContinueContext: context do: aBlock [
	| oldBreakContext oldContinueContext |
	oldBreakContext := currentBreakContext.
	oldContinueContext := currentContinueContext.

	currentBreakContext := context.
	currentContinueContext := context.
	^ aBlock ensure: [
		currentBreakContext := oldBreakContext.
		currentContinueContext := oldContinueContext.
	]
	
]

{ #category : #visiting }
MbndAstEvaluator >> withScope: newEvaluationScope do: aBlock [
	| oldEvaluationScope |
	oldEvaluationScope := scope.
	scope := newEvaluationScope.
	
	^ aBlock ensure: [ 
		scope := oldEvaluationScope
	]
]
