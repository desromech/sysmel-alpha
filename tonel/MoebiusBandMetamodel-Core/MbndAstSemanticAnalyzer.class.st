"
I am an AST visitor that performs semantic analysis.
"
Class {
	#name : #MbndAstSemanticAnalyzer,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'scope',
		'compilationTarget'
	],
	#category : #'MoebiusBandMetamodel-Core-SemanticAnalysis'
}

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
		environment: self;
		signal
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
		method := receiverType lookupSelector: node selector value.
		method ifNotNil: [
			self halt
		].
	
		"We failed to find the method, then ask the receiver type to interpret this message."
		^ receiverType analyzeUnboundExpandedMessageSendNode: node with: self
	].

	^ receiverType analyzeMessageSendNodeWithDynamicSelector: node with: self
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
		receiver: (node receiver ifNotNil: [self analyzeNodeIfNeeded: node receiver]);
		selector: (self analyzeNodeIfNeeded: node selector);
		yourself.

	result selector isLiteralSymbolValueNode ifTrue: [
		"Perform macro lookup."
		selector := result selector value.
		macroMethod := result receiver
			ifNil: [ scope lookupMacroSelector: selector ]
			ifNotNil: [ :receiver | receiver type lookupMacroSelector: selector ].

		"Apply the macro method."
		macroMethod ifNotNil: [
			^ macroMethod expandMessageNode: node with: self
		].
	].

	"No macro found, analyze the node as a normal message send."	
	^ self visitNode: result asExpandedMessageSend
]
