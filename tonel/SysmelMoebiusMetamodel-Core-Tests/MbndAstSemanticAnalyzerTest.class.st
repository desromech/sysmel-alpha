"
A MbndAstSemanticAnalyzerTest is a test class for testing the behavior of MbndAstSemanticAnalyzer
"
Class {
	#name : #MbndAstSemanticAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'scope',
		'visitor',
		'compilationTarget'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-SemanticAnalysis'
}

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> identityFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	^ builder functionNamed: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> identityMessageDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	^ builder messageSelector: #identity: arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #running }
MbndAstSemanticAnalyzerTest >> setUp [
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
	builder := MbndAstBuilder forModule: module.
	scope := MbndLexicalScope parent: (module programEntityScope parent: (MbndGenericMacroLanguageTopLevelScope for: module)).
	visitor := MbndAstSemanticAnalyzer new
		scope: scope;
		module: module
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionApplySend [
	| node analyzedNode |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder unexpandedSend: (builder literalSymbol: #applyWithArguments:)
			to: (builder identifier: #identity)
			withArguments: {builder tuple: { 
				builder literalInteger: 5
			}}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionCall [
	| node analyzedNode |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder call: (builder identifier: #identity) arguments: { 
			builder literalInteger: 5
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionDefinition [
	| arguments node analyzedNode body concreteMethod |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder functionNamed: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionPrototype [
	| arguments node analyzedNode |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	node := builder functionPrototypeNamed: #identity arguments: arguments returnType: compilationTarget int32Type.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isFunctionPrototypeNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityFunctionReference [
	| node analyzedNode |
	node := builder sequence: {
		self identityFunctionDefinitionNode.
		builder identifier: #identity
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityMessageDefinition [
	| arguments node analyzedNode body concreteMethod |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	body := builder identifier: #x.
	node := builder messageSelector: #identity arguments: arguments returnType: compilationTarget int32Type definitionBody: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMessageDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityMessagePrototype [
	| arguments node analyzedNode |
	arguments := {
		builder argument: #x type: compilationTarget int32Type
	}.
	node := builder messagePrototypeSelector: #identity arguments: arguments returnType: compilationTarget int32Type.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMessagePrototypeNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityMessageSend [
	| node analyzedNode |
	node := builder sequence: {
		self identityMessageDefinitionNode.
		builder unexpandedSend: (builder literalSymbol: #identity:) to: nil withArguments: { 
			builder literalInteger: 5
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetAutoMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #assignValue:) to: node withArguments: {
		builder literalInteger: 42
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isLiteralValueNode.
	self assert: analyzedNode initialValue type equals: compilationTarget int32Type.
	self assert: analyzedNode type equals: compilationTarget int32Type.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #type:) to: node withArguments: {
		compilationTarget int32Type asLiteralValueNode
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isLiteralValueNode.
	self assert: analyzedNode type equals: compilationTarget int32Type.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMutableAutoMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #mutable) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #assignValue:) to: node withArguments: {
		builder literalInteger: 42
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isLiteralValueNode.
	self assert: analyzedNode initialValue type equals: compilationTarget int32Type.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType equals: compilationTarget int32Type.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLetMutableMacroBuilderExpansion [
	| node analyzedNode |
	node := builder identifier: #let.
	node := builder unexpandedSend: (builder literalSymbol: #x) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #mutable) to: node withArguments: #().
	node := builder unexpandedSend: (builder literalSymbol: #type:) to: node withArguments: {
		compilationTarget int32Type asLiteralValueNode
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLocalVariableDefinitionNode.
	self assert: analyzedNode initialValue isLiteralValueNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType equals: compilationTarget int32Type.


]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteral [
	| literal analyzedNode |
	literal := builder literalInteger: 42.
	analyzedNode := visitor visitNode: literal.
	self assert: analyzedNode equals: literal
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableMutableDefaultInitialValue [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: compilationTarget int32Type withInitialValue: nil)
			mutable.
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements first initialValue isLiteralValueNode.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableMutableReference [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNew [
	self assert: visitor scope equals: scope
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testReturnMacroExpansion [
	| value node analyzedNode |
	value := builder literalInteger: 42.
	node := builder unexpandedSend: (builder literalSymbol: #return:)
		to: nil withArguments: {value}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isReturnStatementNode.
	self assert: analyzedNode expression equals: value.
	self assert: analyzedNode type isReturnType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testSequence [
	| node analyzedNode |
	node := builder sequence: { 
		builder literalInteger: 1.
		builder literalFloat: 42.
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode .
	self assert: analyzedNode elements size equals: 2.
	self assert: analyzedNode type isLiteralFloatType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testSequenceWithReturn [
	| node analyzedNode |
	node := builder sequence: { 
		builder literalInteger: 1.
		builder return: (builder literalInteger: 42).
		builder literalInteger: 30.
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode .
	self assert: analyzedNode elements size equals: 2.
	self assert: analyzedNode type isReturnType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testVariableReference [
	| node analyzedNode |
	node := builder sequence: { 
		builder defineLocalVariable: #x withValueType: nil withInitialValue: (builder literalInteger: 5).
		builder identifier: #x
	}.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testZeroFunctionDefinition [
	| node analyzedNode body concreteMethod |
	body := builder literalInteger: 0.
	node := builder functionNamed: #zero arguments: #() returnType: compilationTarget int32Type definitionBody: body.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]
