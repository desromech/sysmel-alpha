"
I am an AST visitor that performs semantic analysis.
"
Class {
	#name : #MbndAstSemanticAnalyzer,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'scope',
		'module',
		'compilationTarget',
		'astBuilder'
	],
	#category : #'MoebiusBandMetamodel-Core-SemanticAnalysis'
}

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addImplicitCastFor: nodeRequiringCasting to: expectedTargetType [
	| sourceType |
	sourceType := nodeRequiringCasting type.

	"Omit the cast if not needed."
	sourceType = expectedTargetType ifTrue: [
		^ nodeRequiringCasting
	].

	^ sourceType createNode: nodeRequiringCasting implicitCastTo: expectedTargetType with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeNodeIfNeeded: node [
	"Visit the node only if it does not have a type value."
	^ node type
		ifNil: [ self visitNode: node ]
		ifNotNil: [ node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeNodesIfNeeded: nodes [
	^ nodes collect: [ :node | self analyzeNodeIfNeeded: node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeNonConcreteNodeIfNeeded: node [
	"Visit the node only if it does not have a type value."
	^ node type
		ifNil: [ self visitNonConcreteNode: node ]
		ifNotNil: [ node ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> astBuilder [
	^ astBuilder ifNil: [ astBuilder := MbndAstBuilder forModule: module ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> compilationTarget [
	^ compilationTarget ifNil: [ compilationTarget := scope compilationTarget ]
]

{ #category : #errors }
MbndAstSemanticAnalyzer >> error: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: scope;
		signal
]

{ #category : #'compile time evaluation' }
MbndAstSemanticAnalyzer >> evaluateCompileTimeExpression: compileTimeExpression [
	| returnContext evaluator |
	returnContext := MbndReturnContextScope parent: scope.
	
	evaluator := MbndAstEvaluator new
		scope: returnContext newLexicalScope.
		
	[
		^ evaluator visitNode: compileTimeExpression
	] on: MbndEvaluationReturn do: [ :e |
		e targetReturnContext == returnContext
			ifTrue: [ ^ e returnValue ]
			ifFalse: [ ^ e pass ]
	]
]

{ #category : #'compile time evaluation' }
MbndAstSemanticAnalyzer >> evaluateTypeExpression: typeExpression [
	| evaluationResult |
	evaluationResult := self evaluateCompileTimeExpression: typeExpression.
	evaluationResult type isMetaType ifFalse: [
		^ self error: 'Expected a type expression, instead of an expression evaluated to {1}.' format: { evaluationResult printString } at: typeExpression
	].

	^ evaluationResult value
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> module [
	^ module
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> scope [
	^ scope
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> scope: anObject [
	scope := anObject
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExpandedMessageSendNode: node [
	| result receiverType method |
	result := node copy
		receiver: (self analyzeNodeIfNeeded: node receiver);
		selector: (self analyzeNodeIfNeeded: node selector);
		arguments: (self analyzeNodesIfNeeded: node arguments).
		
	"Find the method in order to perform a typed message send."
	receiverType := result receiver type.
	result selector isLiteralSymbolValueNode ifTrue: [ 
		method := receiverType lookupSelector: result selector value.
		method ifNotNil: [
			self halt
		].
	
		"We failed to find the method, then ask the receiver type to interpret this message."
		^ receiverType analyzeUnboundExpandedMessageSendNode: result with: self
	].

	^ receiverType analyzeMessageSendNodeWithDynamicSelector: result with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitIdentifierReferenceNode: node [
	| binding |
	binding := scope lookupSymbolRecursively: node symbol ifAbsent: [
		self error: 'Failed to find binding for {1}.' format: { node symbol asPrettySymbolName } at: node
	].

	^ binding analyzeReferenceNode: node with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitNode: node [
	^ (node accept: self) concretizeNodeWithAnalyzer: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitNonConcreteNode: node [
	^ node accept: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitReturnStatementNode: node [
	| result |
	result := node copy
		expression: (self visitNode: node expression);
		type: self compilationTarget returnType.

	scope returnType ifNotNil: [ :expectedReturnType |
		result expression: (self addImplicitCastFor: result expression to: expectedReturnType)
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSequenceNode: node [
	| result |
	result := super visitSequenceNode: node.
	result elements
		ifEmpty: [ result type: self compilationTarget voidType ]
		ifNotEmpty: [ result type: result elements last type ].
	self halt
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitUnexpandedMessageSendNode: node [
	| result selector macroMethod |
	result := node copy
		receiver: (node receiver ifNotNil: [self analyzeNonConcreteNodeIfNeeded: node receiver]);
		selector: (self analyzeNodeIfNeeded: node selector);
		yourself.

	result receiver ifNotNil: [
		^ result receiver type analyzeUnexpandedMessageSendNode: result with: self
	].

	result selector isLiteralSymbolValueNode ifFalse: [
		^ self error: 'Invalid message send without receiver. The selector must be a constant.' at: node
	].

	selector := result selector value.
	macroMethod := scope lookupMacroSelector: selector.
	macroMethod ifNil: [
		^ self error: 'Cannot lookup macro method with selector {1}.' format: {selector printString} at: node
	].

	"Apply the macro method."
	^ macroMethod expandMessageNode: node with: self
]