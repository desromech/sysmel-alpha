"
A MbndAstBuilderTest is a test class for testing the behavior of MbndAstBuilder
"
Class {
	#name : #MbndAstBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'builder',
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-AST'
}

{ #category : #running }
MbndAstBuilderTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	
]

{ #category : #tests }
MbndAstBuilderTest >> testArgumentDefinition [
	| node type |
	type := builder identifier: #Int32.
	node := builder argument: #x type: type.
	self assert: node isArgumentDefinitionNode.
	self assert: node name equals: #x.
	self assert: node valueType equals: type.

]

{ #category : #tests }
MbndAstBuilderTest >> testArrayElementReferenceNode [
	| node array index |
	array := builder identifier: #array.
	index := builder literalInteger: 42.
	node := builder array: array elementReferenceAt: index.
	self assert: node isArrayElementReferenceNode.
	self assert: node container equals: array.
	self assert: node index equals: index.
]

{ #category : #tests }
MbndAstBuilderTest >> testAssignmentExpression [
	| node reference value|
	reference := builder identifier: #x.
	value := builder literalInteger: 42.
	node := builder reference: reference assignValue: value.
	self assert: node isAssignmentNode.
	self assert: node reference equals: reference.
	self assert: node value equals: value.
]

{ #category : #tests }
MbndAstBuilderTest >> testAssociationNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder associationKey: one value: two.
	
	self assert: node isAssociationNode.
	self assert: node key equals: one.
	self assert: node value equals: two.
]

{ #category : #tests }
MbndAstBuilderTest >> testBitCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder bitCast: expression to: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isBitCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testBlockClosureNode [
	| returnType body node arguments |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	node := builder blockClosureWithArguments: arguments returnType: returnType body: body.
	self assert: node isBlockClosureNode.
	self assert: node arguments equals: arguments.
	self assert: node returnType equals: returnType.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testBreakStatementNode [
	| node |
	node := builder breakStatement.
	self assert: node isBreakStatementNode.
]

{ #category : #tests }
MbndAstBuilderTest >> testCasesOfCaseNode [
	| node action pattern |
	action := builder literalInteger: 1.
	pattern := builder literalInteger: 2.
	node := builder casesOfCase: pattern do: action.
	
	self assert: node isCasesOfCaseNode.
	self assert: node pattern equals: pattern.
	self assert: node action equals: action.
]

{ #category : #tests }
MbndAstBuilderTest >> testCasesOfDefaultCaseNode [
	| node action |
	action := builder literalInteger: 1.
	node := builder casesOfDefaultCaseDo: action.
	
	self assert: node isCasesOfDefaultCaseNode.
	self assert: node action equals: action.
]

{ #category : #tests }
MbndAstBuilderTest >> testCasesOfNode [
	| node firstCase secondCase matchedExpression |
	firstCase := builder casesOfCase: (builder literalInteger: 1) do: (builder literalInteger: 2).
	secondCase := builder casesOfCase: (builder literalInteger: 3) do: (builder literalInteger: 4).
	matchedExpression := builder identifier: #someElement.
	
	node := builder casesOf: matchedExpression cases: { firstCase . secondCase }.

	self assert: node isCasesOfNode.
	self assert: node matchedExpression equals: matchedExpression.
	self assert: node cases first equals: firstCase.
	self assert: node cases second equals: secondCase.
]

{ #category : #tests }
MbndAstBuilderTest >> testClassDeclarationNode [
	| node |
	node := builder declareClass: #Test.
	self assert: node isClassDeclarationNode.
	self assert: node name equals: #Test.
]

{ #category : #tests }
MbndAstBuilderTest >> testClassDefinitionNode [
	| node superclass body |
	superclass := builder identifier: #Object.
	body := builder sequence: #().
	node := builder defineClassNamed: #Test superclass: superclass body: body.
	self assert: node isClassDefinitionNode.
	self assert: node declaration isClassDeclarationNode.
	self assert: node declaration name equals: #Test.
	self assert: node superclass equals: superclass.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testCleanUpScopeNode [
	| node expression cleanUpActions |
	expression := builder identifier: #hello.
	cleanUpActions := {builder literalVoid}.
	node := builder cleanUpScope: expression actions: cleanUpActions.

	self assert: node isCleanUpScopeNode.
	self assert: node expression equals: expression.
	self assert: node cleanUpActions equals: cleanUpActions.
]

{ #category : #tests }
MbndAstBuilderTest >> testCompileTimeConstantDefinition [
	| node |
	node := builder alias: #Zero definition: (builder literalInteger: 0).	
		
	self assert: node isCompileTimeConstantDefinitionNode.
	self assert: node name equals: #Zero.
	self assert: node value isLiteralValueNode.
]

{ #category : #tests }
MbndAstBuilderTest >> testContinueStatementNode [
	| node |
	node := builder continueStatement.
	self assert: node isContinueStatementNode.
]

{ #category : #tests }
MbndAstBuilderTest >> testDictionaryNode [
	| node associations |
	associations := {
		builder associationKey: (builder literalSymbol: #First) value: (builder literalInteger: 1).
		builder associationKey: (builder literalSymbol: #Second) value: (builder literalInteger: 2).
	}.
	node := builder dictionary: associations.
	
	self assert: node isDictionaryNode.
	self assert: node elements equals: associations.
]

{ #category : #tests }
MbndAstBuilderTest >> testDoWhileLoopNode [
	| node condition action |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 1.
	node := builder do: action while: condition.
	
	self assert: node isDoWhileLoopNode.
	self assert: node condition equals: condition.
	self assert: node action equals: action.
]

{ #category : #tests }
MbndAstBuilderTest >> testEnumDeclarationNode [
	| node |
	node := builder declareEnum: #TestEnum.
	self assert: node isEnumDeclarationNode.
	self assert: node name equals: #TestEnum.
]

{ #category : #tests }
MbndAstBuilderTest >> testEnumDefinitionNode [
	| node valueType body |
	valueType := builder identifier: #Int32.
	body := builder sequence: #().
	node := builder defineEnumNamed: #Test valueType: valueType body: body.
	self assert: node isEnumDefinitionNode.
	self assert: node declaration isEnumDeclarationNode.
	self assert: node declaration name equals: #Test.
	self assert: node valueType equals: valueType.
	self assert: node values equals: nil.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testEnumDefinitionNode2 [
	| node valueType body values |
	valueType := builder identifier: #Int32.
	body := builder sequence: #().
	values := builder dictionary: #().
	node := builder defineEnumNamed: #Test valueType: valueType values: values body: body.
	self assert: node isEnumDefinitionNode.
	self assert: node declaration isEnumDeclarationNode.
	self assert: node declaration name equals: #Test.
	self assert: node valueType equals: valueType.
	self assert: node values equals: values.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testExpandedMessageNode [
	| node receiver arguments selector |
	receiver := builder literalInteger: 1.
	arguments := { 
		builder literalInteger: 4.
		builder literalInteger: 2
	}.

	selector := builder literalSymbol: #to:by:.
	node := builder send: selector to: receiver withArguments: arguments.
	self assert: node isExpandedMessageSendNode .
	self deny: node isUnexpandedMessageSendNode .
	self assert: node receiver equals: receiver.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testExplicitCast [
	| node value targetType |
	value := builder literalInteger: 42.
	targetType := builder identifier: #Float32.
	node := builder explicitCast: value to: targetType.
	self assert: node isExplicitCastNode.
	self assert: node expression equals: value.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testFieldDefinition [
	| node valueType initialValue |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineField: #var withValueType: valueType withInitialValue: initialValue.
	self assert: node isFieldDefinitionNode.
	self assert: node name equals: #var.
	self assert: node valueType equals: valueType.
	self assert: node initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstBuilderTest >> testFloatingPointSizeCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder floatingPointSize: expression to: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isFloatingPointSizeCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testFloatingPointToIntegerCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder floatingPoint: expression toInteger: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isFloatingPointToIntegerCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testFunctionCallNode [
	| node function arguments |
	function := builder identifier: #sqrt.
	arguments := { 
		builder literalFloat: 4.0.
	}.

	node := builder call: function arguments: arguments.
	self assert: node isFunctionCallNode.
	self assert: node function equals: function.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testFunctionDefinitionNode [
	| returnType definition prototype body |
	returnType := builder identifier: #Int32.
	prototype := builder functionPrototypeNamed: #zero arguments: #() returnType: returnType.
	body := builder literalInteger: 0.
	definition := builder functionPrototype: prototype definitionBody: body.
	self assert: definition isFunctionDefinitionNode.
	self assert: definition prototype equals: prototype.
	self assert: definition name equals: #zero.
	self assert: definition arguments equals: #().
	self assert: definition returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testFunctionPrototypeNode [
	| arguments returnType prototype |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := (builder identifier: #Int32).
	prototype := builder functionPrototypeNamed: #add arguments: arguments returnType: returnType.
	self assert: prototype isFunctionPrototypeNode.
	self assert: prototype name equals: #add.
	self assert: prototype arguments equals: arguments.
	self assert: prototype returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testFunctionShortDefinition [
	| returnType definition body |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder functionNamed: #zero arguments: #() returnType: returnType definitionBody: body.
	self assert: definition isFunctionDefinitionNode.
	self assert: definition prototype isNotNil.
	self assert: definition name equals: #zero.
	self assert: definition arguments equals: #().
	self assert: definition returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testGCClassDeclarationNode [
	| node |
	node := builder declareGCClass: #Test.
	self assert: node isGCClassDeclarationNode.
	self assert: node name equals: #Test.
]

{ #category : #tests }
MbndAstBuilderTest >> testGCClassDefinitionNode [
	| node superclass body |
	superclass := builder identifier: #Object.
	body := builder sequence: #().
	node := builder defineGCClassNamed: #Test superclass: superclass body: body.
	self assert: node isGCClassDefinitionNode.
	self assert: node declaration isGCClassDeclarationNode.
	self assert: node declaration name equals: #Test.
	self assert: node superclass equals: superclass.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testGlobalVariableDefinition [
	| node valueType initialValue |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineGlobalVariable: #var withValueType: valueType withInitialValue: initialValue.
	self assert: node isGlobalVariableDefinitionNode.
	self assert: node name equals: #var.
	self assert: node valueType equals: valueType.
	self assert: node initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstBuilderTest >> testIdentifier [
	| node |
	node := builder identifier: #symbol.
	self assert: node isIdentifierReferenceNode.
	self assert: node symbol equals: #symbol.
]

{ #category : #tests }
MbndAstBuilderTest >> testIfConditionNode [
	| node condition trueValue falseValue |
	condition := builder identifier: #predicate.
	trueValue := builder identifier: #trueValue.
	falseValue := builder identifier: #falseValue.
	node := builder if: condition trueValue: trueValue falseValue: falseValue.
	
	self assert: node isIfConditionNode.
	self assert: node condition equals: condition.
	self assert: node trueValue equals: trueValue.
	self assert: node falseValue equals: falseValue.
]

{ #category : #tests }
MbndAstBuilderTest >> testImplicitCast [
	| node value targetType |
	value := builder literalInteger: 42.
	targetType := builder identifier: #Float64.
	node := builder implicitCast: value to: targetType.
	self assert: node isImplicitCastNode.
	self assert: node expression equals: value.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testIntegerToFloatingPointCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder integer: expression toFloatingPoint: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isIntegerToFloatingPointCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLexicalScope2Node [
	| node expression |
	expression := builder identifier: #hello.
	node := expression lexicallyScoped.

	self assert: node isLexicalScopeNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testLexicalScopeNode [
	| node expression |
	expression := builder identifier: #hello.
	node := builder lexicalScope: expression.

	self assert: node isLexicalScopeNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralBoolean [
	| node |
	node := builder literalBoolean: true.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanTrueType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralBoolean2 [
	| node |
	node := builder literalBoolean: false.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanFalseType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralFalse [
	| node |
	node := builder literalBooleanFalse.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanFalseType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralFloat [
	| node |
	node := builder literalFloat: 1.5.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.5.
	self assert: node type isLiteralFloatType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralInteger [
	| node |
	node := builder literalInteger: 1.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.
	self assert: node type isLiteralIntegerType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralString [
	| node |
	node := builder literalString: 'hello'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 'hello'.
	self assert: node type isLiteralStringType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralSymbol [
	| node |
	node := builder literalSymbol: #a.
	self assert: node isLiteralValueNode.
	self assert: node isLiteralSymbolValueNode.
	self assert: node value equals: #a.
	self assert: node type isLiteralSymbolType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralTrue [
	| node |
	node := builder literalBooleanTrue.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanType.
	self assert: node type isLiteralBooleanTrueType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralUndefined [
	| node |
	node := builder literalUndefined.
	self assert: node isLiteralValueNode.
	self assert: node value equals: nil.
	self assert: node type isUndefinedType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralVoid [
	| node |
	node := builder literalVoid.
	self assert: node isLiteralValueNode.
	self assert: node value equals: nil.
	self assert: node type isVoidType.
]

{ #category : #tests }
MbndAstBuilderTest >> testLiteralWithType [
	| node type |
	type := builder compilationTarget int32Type pointer.
	node := builder literal: nil type: type.
	self assert: node isLiteralValueNode.
	self assert: node value equals: nil.
	self assert: node type equals: type.
]

{ #category : #tests }
MbndAstBuilderTest >> testLocalVariableDefinition [
	| node valueType initialValue |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineLocalVariable: #var withValueType: valueType withInitialValue: initialValue.
	self assert: node isLocalVariableDefinitionNode.
	self assert: node name equals: #var.
	self assert: node valueType equals: valueType.
	self assert: node initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstBuilderTest >> testMacroMessageDefinitionNode [
	| returnType definition prototype body |
	returnType := builder identifier: #Int32.
	prototype := builder messagePrototypeSelector: #zero arguments: #() returnType: returnType.
	body := builder literalInteger: 0.
	definition := builder macroMessagePrototype: prototype definitionBody: body.
	self assert: definition isMacroMessageDefinitionNode.
	self assert: definition prototype equals: prototype.
	self assert: definition selector equals: #zero.
	self assert: definition arguments equals: #().
	self assert: definition returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testMacroMessagePrototypeNode [
	| arguments prototype |
	arguments := { 
		builder argument: #x type: nil.
		builder argument: #y type: nil.
	}.
	prototype := builder macroMessagePrototypeSelector: #+ arguments: arguments returnType: nil.
	self assert: prototype isMacroMessagePrototypeNode.
	self assert: prototype selector equals: #+.
	self assert: prototype arguments equals: arguments.
	self assert: prototype returnType equals: nil.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessageChainMessageNode [
	| node arguments selector |
	arguments := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	selector := builder literalSymbol: #selector.
	node := builder messageChainMessageSelector: selector arguments: arguments.
	
	self assert: node isMessageChainMessageNode.
	self assert: node selector equals: selector.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessageChainNode [
	| node chainedMessages receiver |
	chainedMessages := { 
		builder messageChainMessageSelector: (builder literalSymbol: #by:to:) arguments: {
			builder literalInteger: 1.
			builder literalInteger: 2.
		}.
		
		builder messageChainMessageSelector: (builder literalSymbol: #yourself:) arguments: #()
	}.
	
	receiver := builder literalInteger: 1.
	node := builder messageChainReceiver: receiver messages: chainedMessages.
	self assert: node isMessageChainNode.
	self assert: node receiver equals: receiver.
	self assert: node messages equals: chainedMessages.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessageDefinitionNode [
	| returnType definition prototype body |
	returnType := builder identifier: #Int32.
	prototype := builder messagePrototypeSelector: #zero arguments: #() returnType: returnType.
	body := builder literalInteger: 0.
	definition := builder messagePrototype: prototype definitionBody: body.
	self assert: definition isMessageDefinitionNode.
	self assert: definition prototype equals: prototype.
	self assert: definition selector equals: #zero.
	self assert: definition arguments equals: #().
	self assert: definition returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessagePrototypeNode [
	| arguments returnType prototype |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := (builder identifier: #Int32).
	prototype := builder messagePrototypeSelector: #+ arguments: arguments returnType: returnType.
	self assert: prototype isMessagePrototypeNode.
	self assert: prototype selector equals: #+.
	self assert: prototype arguments equals: arguments.
	self assert: prototype returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testMessageShortDefinition [
	| returnType definition body |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder messageSelector: #zero arguments: #() returnType: returnType definitionBody: body.
	self assert: definition isMessageDefinitionNode.
	self assert: definition prototype isNotNil.
	self assert: definition selector equals: #zero.
	self assert: definition arguments equals: #().
	self assert: definition returnType equals: returnType.
]

{ #category : #tests }
MbndAstBuilderTest >> testModule [
	self assert: builder module equals: module
]

{ #category : #tests }
MbndAstBuilderTest >> testNamespaceDefinition [
	| node body |
	body := builder sequence: #().
	node := builder namespace: #HelloNamespace definition: body.
	
	self assert: node isNamespaceDefinitionNode.
	self assert: node name equals: #HelloNamespace.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testPointerAsReference [
	| node pointer |
	pointer := builder identifier: #x.
	node := builder pointerAsReference: pointer.
	self assert: node isPointerAsReferenceNode.
	self assert: node pointer equals: pointer.
]

{ #category : #tests }
MbndAstBuilderTest >> testPointerElementReferenceNode [
	| node pointer index |
	pointer := builder identifier: #pointer.
	index := builder literalInteger: 42.
	node := builder pointer: pointer elementReferenceAt: index.
	self assert: node isPointerElementReferenceNode.
	self assert: node container equals: pointer.
	self assert: node index equals: index.
]

{ #category : #tests }
MbndAstBuilderTest >> testPragmaNode [
	| node arguments |
	arguments := {
		builder literalInteger: 1.
		builder literalInteger: 2
	}.
	
	node := builder pragmaSelector: #somePragma:with: arguments: arguments.

	self assert: node isPragmaNode.
	self assert: node selector equals: #somePragma:with:.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testQuasiQuoteNode [
	| node quoted |
	quoted := builder literalInteger: 1.
	node := builder quasiQuote: quoted.

	self assert: node isQuasiQuoteNode.
	self assert: node expression equals: quoted.
]

{ #category : #tests }
MbndAstBuilderTest >> testQuasiUnquoteNode [
	| node expression |
	expression := builder literalInteger: 1.
	node := builder quasiUnquote: expression.

	self assert: node isQuasiUnquoteNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testQuoteNode [
	| node quoted |
	quoted := builder literalInteger: 1.
	node := builder quote: quoted.

	self assert: node isQuoteNode.
	self assert: node expression equals: quoted.
]

{ #category : #tests }
MbndAstBuilderTest >> testReferenceAsPointer [
	| node reference |
	reference := builder identifier: #x.
	node := builder referenceAsPointer: reference.
	self assert: node isReferenceAsPointerNode.
	self assert: node reference equals: reference.
]

{ #category : #tests }
MbndAstBuilderTest >> testReferenceLoad [
	| node reference |
	reference := builder identifier: #x.
	node := builder referenceLoad: reference.
	self assert: node isReferenceLoadNode.
	self assert: node reference equals: reference.
]

{ #category : #tests }
MbndAstBuilderTest >> testReinterpretCast [
	| node value targetType |
	value := builder literalInteger: 42.
	targetType := builder identifier: #VoidPtr.
	node := builder reinterpretCast: value to: targetType.
	self assert: node isReinterpretCastNode.
	self assert: node expression equals: value.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testReturnNode [
	| node expression |
	expression := builder identifier: #predicate.
	node := builder return: expression.
	
	self assert: node isReturnStatementNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testSequenceNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder sequence: { one . two }.
	
	self assert: node isSequenceNode.
	self assert: node elements equals: {one . two}.
]

{ #category : #tests }
MbndAstBuilderTest >> testSequenceWithPragmaNode [
	| pragmas expressions node |
	pragmas := { 
		builder pragmaSelector: #nullaryPragma arguments: #().
		builder pragmaSelector: #unaryPragma arguments: {
			builder literalInteger: 42.
		}
	}.
	
	expressions := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmas: pragmas sequence: expressions.
	
	self assert: node isSequenceNode.
	self assert: node pragmas equals: pragmas.
	self assert: node elements equals: expressions.
]

{ #category : #tests }
MbndAstBuilderTest >> testSignExtensionCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder signExtend: expression to: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isSignExtensionCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testSpliceNode [
	| node expression |
	expression := builder literalInteger: 1.
	node := builder splice: expression.

	self assert: node isSpliceNode.
	self assert: node expression equals: expression.
]

{ #category : #tests }
MbndAstBuilderTest >> testStructureDeclarationNode [
	| node |
	node := builder declareStructure: #Test.
	self assert: node isStructureDeclarationNode.
	self assert: node name equals: #Test.
]

{ #category : #tests }
MbndAstBuilderTest >> testStructureDefinitionNode [
	| node body |
	body := builder sequence: #().
	node := builder defineStructureNamed: #Test body: body.
	self assert: node isStructureDefinitionNode.
	self assert: node declaration isStructureDeclarationNode.
	self assert: node declaration name equals: #Test.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testTemplateDefinition [
	| arguments body node |
	arguments := {
		builder argument: #T type: (builder identifier: #Type).
	}.
	body := builder defineStructureNamed: #_ body: { 
		builder defineField: #value withValueType: (builder identifier: #T) withInitialValue: nil
	}.
	node := builder defineTemplate: #ValueHolder arguments: arguments body: body.
	
	self assert: node isTemplateDefinitionNode.
	self assert: node name equals: #ValueHolder.
	self assert: node arguments equals: arguments.
	self assert: node body isStructureDefinitionNode.

]

{ #category : #tests }
MbndAstBuilderTest >> testTruncateCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder truncate: expression to: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isTruncateCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]

{ #category : #tests }
MbndAstBuilderTest >> testTupleNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder tuple: { one . two }.
	
	self assert: node isTupleNode.
	self assert: node elements equals: {one . two}.
]

{ #category : #tests }
MbndAstBuilderTest >> testUnexpandedMessageNode [
	| node receiver arguments selector |
	receiver := builder literalInteger: 1.
	arguments := { 
		builder literalInteger: 4.
		builder literalInteger: 2
	}.

	selector := builder literalSymbol: #to:by:.
	node := builder unexpandedSend: #selector to: receiver withArguments: arguments.
	self assert: node isUnexpandedMessageSendNode .
	self deny: node isExpandedMessageSendNode .
	self assert: node receiver equals: receiver.
	self assert: node arguments equals: arguments.
]

{ #category : #tests }
MbndAstBuilderTest >> testUnionDeclarationNode [
	| node |
	node := builder declareUnion: #Test.
	self assert: node isUnionDeclarationNode.
	self assert: node name equals: #Test.
]

{ #category : #tests }
MbndAstBuilderTest >> testUnionDefinitionNode [
	| node body |
	body := builder sequence: #().
	node := builder defineUnionNamed: #Test body: body.
	self assert: node isUnionDefinitionNode.
	self assert: node declaration isUnionDeclarationNode.
	self assert: node declaration name equals: #Test.
	self assert: node body equals: body.
]

{ #category : #tests }
MbndAstBuilderTest >> testVariableReference [
	| node dummyBinding |
	dummyBinding := MbndFunctionLocalVariable new
		valueType: module compilationTarget int32Type;
		type: module compilationTarget int32Type ref;
		yourself.
	node := builder variableReference: dummyBinding.
	self assert: node isBoundIdentifierReferenceNode.
	self assert: node isVariableReferenceNode.
	self assert: node type equals: dummyBinding type.
]

{ #category : #tests }
MbndAstBuilderTest >> testVectorConstructionNode [
	| node one two |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder constructVector: (builder identifier: #Float32x4) withElements: { one . two }.
	
	self assert: node isVectorConstructionNode.
	self assert: node elements equals: {one . two}.
]

{ #category : #tests }
MbndAstBuilderTest >> testWhileLoopNode [
	| node condition action continueAction |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 1.
	continueAction := builder literalInteger: 1.
	node := builder while: condition do: action continueWith: continueAction.
	
	self assert: node isWhileLoopNode.
	self assert: node condition equals: condition.
	self assert: node action equals: action.
	self assert: node continueAction equals: continueAction.
	
]

{ #category : #tests }
MbndAstBuilderTest >> testZeroExtensionCastNode [
	| expression node  targetType |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder zeroExtend: expression to: targetType.
	self assert: node isAbstractCastNode.
	self assert: node isSpecificCastNode.
	self assert: node isNumericalCastNode.
	self assert: node isZeroExtensionCastNode.
	self assert: node expression equals: expression.
	self assert: node targetType equals: targetType.
]
