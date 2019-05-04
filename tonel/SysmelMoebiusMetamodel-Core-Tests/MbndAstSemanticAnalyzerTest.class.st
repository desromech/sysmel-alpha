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

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzerTest >> countTwiceFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #destCount type: compilationTarget int32Type.
	}.
	body := builder sequence: {
		(builder defineLocalVariable: #i withValueType: nil withInitialValue: (builder literalInteger: 0))
			mutable.
		(builder defineLocalVariable: #count withValueType: nil withInitialValue: (builder literalInteger: 0))
			mutable.
			
		builder while: (builder unexpandedSend: (builder literalSymbol: #<)
			to: (builder identifier: #i) withArguments: {(builder identifier: #destCount)})
			do: (builder sequence: {
				builder unexpandedSend: (builder literalSymbol: #assignValue:)
					to:  (builder identifier: #count)
					withArguments: {
						builder unexpandedSend: (builder literalSymbol: #+)
							to: (builder identifier: #count) withArguments: { builder literalInteger: 2 }.
					}
			}) continueWith: (builder unexpandedSend: (builder literalSymbol: #assignValue:)
					to:  (builder identifier: #i)
					withArguments: {
						builder unexpandedSend: (builder literalSymbol: #+)
							to: (builder identifier: #i) withArguments: { builder literalInteger: 1 }.
					}).
		builder identifier: #count
	}.
	
	^ builder functionNamed: #countTwice arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

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

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> identityTopMacroDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #x type: nil.
	}.
	body := builder identifier: #x.
	^ builder macroMessageSelector: #identity: arguments: arguments returnType: nil definitionBody: body
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> libcPrintfDeclarationNode [
	| arguments |
	arguments := {
		builder argument: #format type: compilationTarget cstringLiteralType
	}.
	^ (builder functionPrototypeNamed: #printf arguments: arguments returnType: compilationTarget int32Type)
		externC;
		CVariadic;
		yourself
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> libcPutsDefinitionNode [
	| arguments |
	arguments := {
		builder argument: #s type: compilationTarget cstringLiteralType
	}.
	^ (builder functionPrototypeNamed: #puts arguments: arguments returnType: compilationTarget int32Type)
		externC;
		yourself
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> minFunctionDefinitionNode [
	| arguments body |
	arguments := {
		builder argument: #a type: compilationTarget int32Type.
		builder argument: #b type: compilationTarget int32Type.
	}.
	body := builder if: (builder unexpandedSend: (builder literalSymbol: #<=)
			to: (builder identifier: #a) withArguments: { builder identifier: #b })
		trueValue: (builder identifier: #a) falseValue: (builder identifier: #b).
	^ builder functionNamed: #min arguments: arguments returnType: compilationTarget int32Type definitionBody: body
]

{ #category : #running }
MbndAstSemanticAnalyzerTest >> setUp [
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
	builder := MbndAstBuilder forModule: module.
	scope := module newGenericAnalysisScope.
	visitor := MbndAstSemanticAnalyzer new
		scope: scope;
		module: module
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCompileTimeConstantDefinition [
	| node analyzedNode |
	node := builder alias: #int definition: (builder identifier: #Int32).

	self assert: (module globalNamespace lookupSymbol: #int) isNil.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isVoidType.
	self assert: (module globalNamespace lookupSymbol: #int) isCompileTimeConstant.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCompileTimeConstantReference [
	| node analyzedNode |
	node := builder sequence: {
		builder alias: #int definition: (builder identifier: #Int32).
		builder identifier: #int
	}.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isMetaType.
	self assert: analyzedNode elements last isLiteralValueNode.
	self assert: analyzedNode elements last value isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testCountTwiceFunctionDefinition [
	| node analyzedNode concreteMethod |
	node := self countTwiceFunctionDefinitionNode.
	
	self assert: (module globalNamespace lookupSymbol: #countTwice) isNil.
		
	analyzedNode := visitor visitNode: node.
	self assert: (module globalNamespace lookupSymbol: #countTwice) isMethod.
	self deny: (module globalNamespace lookupSymbol: #countTwice) isMethodGroup.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: (module globalNamespace lookupSymbol: #countTwice) equals: concreteMethod.
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testDummyLexicalScopeNode [
	| node analyzedNode |
	node := builder lexicalScope: (builder sequence: {
		builder literalInteger: 1.
		builder literalInteger: 42
	}).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testDummyLexicalScopeWithSingleLiteral [
	| node analyzedNode literalNode |
	literalNode := builder literalInteger: 42.
	node := builder lexicalScope: literalNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: literalNode.
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
MbndAstSemanticAnalyzerTest >> testIdentityFunctionCallInNamespace [
	| node analyzedNode |
	node := builder sequence: {
		builder namespace: #TestNamespace definition: self identityFunctionDefinitionNode.
		builder call: (builder unexpandedSend: (builder literalSymbol: #identity)
				to: (builder identifier: #TestNamespace)
				withArguments: #()) arguments: { 
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
	
	self assert: (module globalNamespace lookupSymbol: #identity) isNil.
		
	analyzedNode := visitor visitNode: node.
	self assert: (module globalNamespace lookupSymbol: #identity) isMethod.
	self deny: (module globalNamespace lookupSymbol: #identity) isMethodGroup.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: (module globalNamespace lookupSymbol: #identity) equals: concreteMethod.
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
MbndAstSemanticAnalyzerTest >> testIdentityTopMacroDefinition [
	| node analyzedNode concreteMethod |
	node := self identityTopMacroDefinitionNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isMacroMessageDefinitionNode.
	self assert: analyzedNode arguments first valueType isASTNodeType.
	self assert: analyzedNode returnType isASTNodeType.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isFunctionType.
	self assert: analyzedNode concreteMethod isNotNil.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIdentityTopMacroUsage [
	| analyzedNode |
	
	visitor visitNode: self identityTopMacroDefinitionNode.
	
	analyzedNode := visitor visitNode: (
		builder unexpandedSend: (builder literalSymbol: #identity:) to: nil
			withArguments: {
				builder literalInteger: 42
			}).
	self assert: analyzedNode isLiteralValueNode.
	self assert: analyzedNode value equals: 42.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIfLiteralFalse [
	| node analyzedNode trueNode falseNode |
	trueNode := builder literalInteger: 42.
	falseNode := builder literalInteger: 0.
	node := builder if: (builder literalBooleanTrue)
		trueValue: trueNode
		falseValue: falseNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: trueNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testIfLiteralTrue [
	| node analyzedNode trueNode falseNode |
	trueNode := builder literalInteger: 42.
	falseNode := builder literalInteger: 0.
	node := builder if: (builder literalBooleanTrue)
		trueValue: trueNode
		falseValue: falseNode.
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode equals: trueNode.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInvalidQuasiUnquote [
	| node |
	node := builder quasiUnquote: (builder quote: (builder literalInteger: 42)).
	self should: [visitor visitNode: node] raise: MbndSemanticError.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testInvalidSplice [
	| node |
	node := builder splice: (builder quote: (builder literalInteger: 42)).
	self should: [visitor visitNode: node] raise: MbndSemanticError.
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
	self assert: (scope lookupSymbol: #x) isNotNil.
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
	self assert: (scope lookupSymbol: #x) isNotNil.
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
	self assert: (scope lookupSymbol: #x) isNotNil.
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
	self assert: (scope lookupSymbol: #x) isNotNil.
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
	self assert: analyzedNode equals: literal.
	self assert: analyzedNode type isLiteralIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralIntegerExplicitCast [
	| node analyzedNode |
	node := builder explicitCast: (builder literalInteger: 42) to: (builder identifier: #Float32).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveFloatType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralIntegerImplicitCast [
	| node analyzedNode |
	node := builder implicitCast: (builder literalInteger: 42) to: (builder identifier: #Float32).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isPrimitiveFloatType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLiteralIntegerReinterpretCast [
	| node analyzedNode |
	node := builder reinterpretCast: (builder literalInteger: 42) to: (compilationTarget void pointer).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isReinterpretCastNode.
	self assert: analyzedNode type isPointerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableMutableAssignment [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: (builder identifier: #Int32) withInitialValue: nil)
			mutable.
		builder reference: (builder identifier: #x) assignValue: (builder literalInteger: 5).
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
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
	self assert: (scope lookupSymbol: #x) isNotNil.
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
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableMutableReferenceExplicitLoad [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder referenceLoad: (builder identifier: #x)
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableMutableReferenceImplicitLoad [
	| node analyzedNode |
	node := builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder unexpandedSend: (builder literalSymbol: #+)
			to: (builder identifier: #x)
			withArguments: { 
			(builder literalInteger: 1)
		}
	}.
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) isNotNil.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableScopeReference [
	| node analyzedNode |
	node := builder lexicalScope: (builder sequence: { 
		(builder defineLocalVariable: #x withValueType: nil withInitialValue:
			(builder literalInteger: 5))
			mutable.
		builder identifier: #x
	}).
	
	analyzedNode := visitor visitNode: node.
	self assert: (scope lookupSymbol: #x) equals: nil.
	self assert: analyzedNode isLexicalScopeNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.
	self assert: analyzedNode expression elements last isBoundIdentifierReferenceNode.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testLocalVariableScopeReferenceError [
	| node |
	node := builder sequence: {
			builder lexicalScope: (builder sequence: { 
				(builder defineLocalVariable: #x withValueType: nil withInitialValue:
				(builder literalInteger: 5))
				mutable.
		}) .
		builder identifier: #x
	}.
	self should: [ visitor visitNode: node ] raise: Error
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testMinFunctionDefinition [
	| node analyzedNode concreteMethod |
	node := self minFunctionDefinitionNode.
	
	self assert: (module globalNamespace lookupSymbol: #min) isNil.
		
	analyzedNode := visitor visitNode: node.
	self assert: (module globalNamespace lookupSymbol: #min) isMethod.
	self deny: (module globalNamespace lookupSymbol: #min) isMethodGroup.
	self assert: analyzedNode isFunctionDefinitionNode.
	self assert: analyzedNode arguments first valueType isPrimitiveIntegerType.
	self assert: analyzedNode arguments second valueType isPrimitiveIntegerType.
	self assert: analyzedNode returnType isPrimitiveIntegerType.
	
	concreteMethod := analyzedNode concreteMethod.
	concreteMethod ensureSemanticAnalysis.
	
	self assert: (module globalNamespace lookupSymbol: #min) equals: concreteMethod.
	self assert: concreteMethod analyzedBody isNotNil.
	self assert: concreteMethod analyzedBody type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNamespaceDefinition [
	| node analyzedNode |
	node := builder namespace: #HelloNamespace definition: (builder literalInteger: 42).

	self assert: (module globalNamespace lookupSymbol: #HelloNamespace) isNil.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isVoidType.
	self assert: (module globalNamespace lookupSymbol: #HelloNamespace) isNamespace.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNamespaceReference [
	| node analyzedNode |
	node := builder sequence: {
		builder namespace: #HelloNamespace definition: (builder literalInteger: 42).
		builder identifier: #HelloNamespace
	}.

	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode type isNamespaceType.
	self assert: analyzedNode elements last value equals: (module globalNamespace lookupSymbol: #HelloNamespace).

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testNew [
	self assert: visitor scope equals: scope
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerElementReferenceNode [
	| node analyzedNode |
	node := builder pointer: (builder literal: nil type: compilationTarget int32Type pointer) elementReferenceAt: (builder literalInteger: 1).
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isPointerElementReferenceNode.
	self assert: analyzedNode type isReferenceType.
	self assert: analyzedNode type baseType isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPointerTypeConstruction [
	| node analyzedNode |
	node := builder unexpandedSend: (builder literalSymbol: #pointer)
		to: (builder identifier: #Int32)
		withArguments: #().
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isLiteralValueNode.
	self assert: analyzedNode value isPointerType.
	self assert: analyzedNode type isMetaType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPrintfCall [
	| node analyzedNode |
	node := builder sequence: {
		self libcPrintfDeclarationNode.
		builder call: (builder identifier: #printf) arguments: { 
			builder literalString: 'Hello World:'.
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPrintfCallWithIntegerAndFloatArgument [
	| node analyzedNode |
	node := builder sequence: {
		self libcPrintfDeclarationNode.
		builder call: (builder identifier: #printf) arguments: { 
			builder literalString: 'Hello World: %d %f'.
			builder literalInteger: 42.
			builder literalFloat: 42.0.
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPrintfCallWithIntegerArgument [
	| node analyzedNode |
	node := builder sequence: {
		self libcPrintfDeclarationNode.
		builder call: (builder identifier: #printf) arguments: { 
			builder literalString: 'Hello World: %d'.
			builder literalInteger: 42.
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testPutsCall [
	| node analyzedNode |
	node := builder sequence: {
		self libcPutsDefinitionNode.
		builder call: (builder identifier: #puts) arguments: { 
			builder literalString: 'Hello World'
		}
	}.
	
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isSequenceNode.
	self assert: analyzedNode type isPrimitiveIntegerType.

]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testQuasiQuoteLiteral [
	| node analyzedNode |
	node := builder quasiQuote: (builder literalInteger: 42).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isQuasiQuoteNode.
	self assert: analyzedNode type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testQuasiQuoteUnquoteQuoteLiteral [
	| node analyzedNode |
	node := builder quasiQuote: (builder quasiUnquote: (builder quote: (builder literalInteger: 42))).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isQuasiQuoteNode.
	self assert: analyzedNode type isASTNodeType.
]

{ #category : #tests }
MbndAstSemanticAnalyzerTest >> testQuote [
	| node analyzedNode |
	node := builder quote: (builder literalInteger: 42).
	analyzedNode := visitor visitNode: node.
	self assert: analyzedNode isQuoteNode.
	self assert: analyzedNode type isASTNodeType.
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
	self assert: analyzedNode type isPrimitiveFloatType.
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
