"
A MbndAstTransformVisitorTest is a test class for testing the behavior of MbndAstTransformVisitor
"
Class {
	#name : #MbndAstTransformVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'visitor'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-AST'
}

{ #category : #running }
MbndAstTransformVisitorTest >> setUp [
	module := MbndDummyModule new.
	builder := MbndAstBuilder forModule: module.
	visitor := MbndAstTransformVisitor new.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testArgumentDefinition [
	| node type transformedNode |
	type := builder identifier: #Int32.
	node := builder argument: #x type: type.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isArgumentDefinitionNode.
	self assert: transformedNode name equals: #x.
	self assert: transformedNode valueType equals: type.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testArrayConstructionNode [
	| node one two transfomedNode |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder constructArrayOf: (builder identifier: #Float32) withElements: { one . two }.
	transfomedNode := visitor visitNode: node.
	
	self assert: node ~~ transfomedNode.
	self assert: transfomedNode isArrayConstructionNode.
	self assert: transfomedNode elements equals: {one . two}.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testArrayElementReferenceNode [
	| node array index transformedNode |
	array := builder identifier: #tr.
	index := builder literalInteger: 42.
	node := builder array: array elementReferenceAt: index.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isArrayElementReferenceNode.
	self assert: transformedNode container equals: array.
	self assert: transformedNode index equals: index.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testArraySliceElementReferenceNode [
	| node array index transformedNode |
	array := builder identifier: #tr.
	index := builder literalInteger: 42.
	node := builder arraySlice: array elementReferenceAt: index.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isArraySliceElementReferenceNode.
	self assert: transformedNode container equals: array.
	self assert: transformedNode index equals: index.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testAssignmentExpression [
	| node reference value transformedNode |
	reference := builder identifier: #x.
	value := builder literalInteger: 42.
	node := builder reference: reference assignValue: value.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isAssignmentNode.
	self assert: transformedNode reference equals: reference.
	self assert: transformedNode value equals: value.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testAssociationNode [
	| one two node transformedNode |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	node := builder associationKey: one value: two.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode key equals: one.
	self assert: transformedNode value equals: two.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testBitCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder bitCast: expression to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isBitCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testBlockClosureNode [
	| returnType body node arguments transformedNode |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	node := builder blockClosureWithArguments: arguments returnType: returnType body: body.
	transformedNode := visitor visitNode: node.
	
	self assert: transformedNode ~~ node.
	self assert: transformedNode isBlockClosureNode.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode arguments first type equals: arguments first type.
	self assert: transformedNode arguments second name equals: arguments second name.
	self assert: transformedNode arguments second type equals: arguments second type.
	self assert: transformedNode returnType equals: returnType.
	self assert: transformedNode body equals: body.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testBreakStatement [
	| node transformedNode |
	node := builder breakStatement.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCasesOfCaseNode [
	| node transformedNode action pattern |
	pattern := builder literalInteger: 42.
	action := builder literalInteger: 1.
	node := builder casesOfCase: pattern do: action.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode pattern equals: pattern.
	self assert: transformedNode action equals: action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCasesOfNode [
	| node transformedNode firstCase secondCase matchedExpression |
	firstCase := builder casesOfCase: (builder literalInteger: 1) do: (builder literalInteger: 2).
	secondCase := builder casesOfCase: (builder literalInteger: 3) do: (builder literalInteger: 4).
	matchedExpression := builder identifier: #someElement.
	
	node := builder casesOf: matchedExpression cases: { firstCase . secondCase }.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode matchedExpression equals: matchedExpression.
	self assert: transformedNode cases first pattern equals: firstCase pattern.
	self assert: transformedNode cases first action equals: firstCase action.
	self assert: transformedNode cases second pattern equals: secondCase pattern.
	self assert: transformedNode cases second action equals: secondCase action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testClassDeclarationNode [
	| node transformedNode |
	node := builder declareClass: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isClassDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testClassDefinitionNode [
	| node superclass body transformedNode |
	superclass := builder identifier: #Object.
	body := builder sequence: #().
	node := builder defineClassNamed: #Test superclass: superclass body: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isClassDefinitionNode.
	self assert: transformedNode declaration isClassDeclarationNode.
	self assert: transformedNode declaration name equals: #Test.
	self assert: transformedNode superclass equals: superclass.
	self assert: transformedNode body elements equals: body elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCleanUpScopeNode [
	| node expression cleanUpActions transformedNode |
	expression := builder identifier: #hello.
	cleanUpActions := {builder literalVoid}.
	node := builder cleanUpScope: expression actions: cleanUpActions.

	transformedNode := visitor visitNode: node.
	self assert: transformedNode isExceptionScopeNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode explicitCleanUpActions equals: cleanUpActions.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testCompileTimeConstantDefinition [
	| node transformedNode value |
	value := builder identifier: #Int32.
	node := builder alias: #Int definition: value.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isCompileTimeConstantDefinitionNode.
	self assert: transformedNode name equals: #Int.
	self assert: transformedNode value equals: value.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testContinueStatement [
	| node transformedNode |
	node := builder continueStatement.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testDictionaryNode [
	| node transformedNode elements |
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder dictionary: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode elements equals: elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testDoWhileLoopNode [
	| node transformedNode condition action |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 42.

	node := builder do: action while: condition.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode condition equals: node condition.
	self assert: transformedNode action equals: node action.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testEnumDeclarationNode [
	| node transformedNode |
	node := builder declareEnum: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isEnumDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testExpandedMessageSendNode [
	| node transformedNode receiver selector arguments |
	receiver := builder literalInteger: 1.
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	node := builder unexpandedSend: selector to: receiver withArguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode receiver equals: node receiver.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testExplicitCast [
	| node value targetType transformedNode |
	value := builder literalInteger: 42.
	targetType := builder identifier: #Float32.
	node := builder explicitCast: value to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isExplicitCastNode.
	self assert: transformedNode expression equals: value.
	self assert: transformedNode targetType equals: targetType.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFieldDefinition [
	| node valueType initialValue transformedNode |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineField: #f withValueType: valueType withInitialValue: initialValue.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isFieldDefinitionNode.
	self assert: transformedNode name equals: node name.
	self assert: transformedNode valueType equals: valueType.
	self assert: transformedNode initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFloatingPointSizeCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder floatingPointSize: expression to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isFloatingPointSizeCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFloatingPointToIntegerCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder floatingPoint: expression toInteger: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isFloatingPointToIntegerCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFunctionCallNode [
	| node transformedNode function arguments |
	function := builder identifier: #sqrt.
	arguments := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.

	node := builder call: function arguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode function equals: function.
	self assert: transformedNode arguments equals: arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFunctionDefinitionNode [
	| returnType definition body transformedNode |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder functionNamed: #zero arguments: #() returnType: returnType definitionBody: body.
	transformedNode := visitor visitNode: definition.
	self assert: transformedNode ~~ definition.
	self assert: transformedNode prototype ~~ definition prototype.
	self assert: transformedNode isFunctionDefinitionNode.
	self assert: transformedNode prototype isFunctionPrototypeNode.
	self assert: transformedNode name equals: #zero.
	self assert: transformedNode arguments equals: #().
	self assert: transformedNode returnType equals: returnType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testFunctionPrototypeNode [
	| arguments returnType prototype transformedNode |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := (builder identifier: #Int32).
	prototype := builder functionPrototypeNamed: #add arguments: arguments returnType: returnType.
	transformedNode := visitor visitNode: prototype.
	self assert: transformedNode ~~ prototype.
	self assert: transformedNode isFunctionPrototypeNode.
	self assert: transformedNode name equals: prototype name.

	self assert: transformedNode arguments first ~~ arguments first.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode arguments first type equals: arguments first type.

	self assert: transformedNode arguments second ~~ arguments second.
	self assert: transformedNode arguments second name equals: arguments second name.
	self assert: transformedNode arguments second type equals: arguments second type.

	self assert: transformedNode returnType equals: returnType.
	
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testGCClassDeclarationNode [
	| node transformedNode |
	node := builder declareGCClass: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isGCClassDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testGCClassDefinitionNode [
	| node superclass body transformedNode |
	superclass := builder identifier: #Object.
	body := builder sequence: #().
	node := builder defineGCClassNamed: #Test superclass: superclass body: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isGCClassDefinitionNode.
	self assert: transformedNode declaration isGCClassDeclarationNode.
	self assert: transformedNode declaration name equals: #Test.
	self assert: transformedNode superclass equals: superclass.
	self assert: transformedNode body elements equals: body elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testGlobalVariableDefinition [
	| node valueType initialValue transformedNode |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineGlobalVariable: #var withValueType: valueType withInitialValue: initialValue.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode name equals: node name.
	self assert: transformedNode valueType equals: valueType.
	self assert: transformedNode initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIOChannelReceiveNode [
	| node channel transformedNode |
	channel := builder identifier: #channel.
	node := builder receiveFromInputChannel: channel.
	transformedNode := visitor visitNode: node.
	
	self assert: transformedNode ~~ node.
	self assert: transformedNode isIOChannelActionNode.
	self assert: transformedNode isIOChannelReceiveActionNode.
	self assert: transformedNode channel equals: channel.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIOChannelSendNode [
	| node channel message transformedNode |
	channel := builder identifier: #channel.
	message := builder identifier: #message.
	node := builder sendIntoOutputChannel: channel message: message.
	transformedNode := visitor visitNode: node.
	
	self assert: transformedNode ~~ node.
	self assert: transformedNode isIOChannelActionNode.
	self assert: transformedNode isIOChannelSendActionNode.
	self assert: transformedNode channel equals: channel.
	self assert: transformedNode message equals: message.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIdentifierReference [
	| node transformedNode |
	node := builder identifier: #ident.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIfConditionNode [
	| node transformedNode condition trueValue falseValue |
	condition := builder identifier: #predicate.
	trueValue := builder literalInteger: 1.
	falseValue := builder literalInteger: 2.
	
	node := builder if: condition trueValue: trueValue falseValue: falseValue.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode condition equals: node condition.
	self assert: transformedNode trueValue equals: node trueValue.
	self assert: transformedNode falseValue equals: node falseValue.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testImplicitCast [
	| node value targetType transformedNode |
	value := builder literalInteger: 42.
	targetType := builder identifier: #Float32.
	node := builder implicitCast: value to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isImplicitCastNode.
	self assert: transformedNode expression equals: value.
	self assert: transformedNode targetType equals: targetType.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testInlineAssemblyNode [
	| node assembly architecture dialect inputList outputList clobberList transformedNode |
	assembly := builder literalString: #nop.
	architecture := builder literalSymbol: #x86.
	dialect := builder literalSymbol: #gas.
	inputList := builder tuple: #().
	outputList := builder tuple: #().
	clobberList := builder tuple: #().
	node := builder inlineAssembly: assembly
		architecture: architecture
		dialect: dialect
		inputList: inputList
		outputList: outputList
		clobberList: clobberList.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isInlineAssembly.
	self assert: transformedNode architecture equals: architecture.
	self assert: transformedNode dialect equals: dialect.

	self assert: transformedNode inputList isTupleNode.
	self deny: transformedNode inputList equals: inputList.

	self assert: transformedNode outputList isTupleNode.
	self deny: transformedNode outputList equals: outputList.

	self assert: transformedNode clobberList isTupleNode.
	self deny: transformedNode clobberList equals: clobberList.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testIntegerToFloatingPointCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder integer: expression toFloatingPoint: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isIntegerToFloatingPointCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testInterfaceDeclarationNode [
	| node transformedNode |
	node := builder declareInterface: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isInterfaceDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testInterfaceDefinitionNode [
	| node body transformedNode |
	body := builder sequence: #().
	node := builder defineInterfaceNamed: #Test body: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isInterfaceDefinitionNode.
	self assert: transformedNode declaration isInterfaceDeclarationNode.
	self assert: transformedNode declaration name equals: #Test.
	self assert: transformedNode body elements equals: body elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testLexicalScopeNode [
	| node transformedNode scoped |
	scoped := builder identifier: #predicate.

	node := scoped lexicallyScoped.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: scoped.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testLiteralValueNode [
	| node transformedNode |
	node := builder literalInteger: 1.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode equals: node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testLocalVariableDefinition [
	| node valueType initialValue transformedNode |
	valueType := module compilationTarget int32Type.
	initialValue := builder literalInteger: 42.
	node := builder defineLocalVariable: #var withValueType: valueType withInitialValue: initialValue.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode name equals: node name.
	self assert: transformedNode valueType equals: valueType.
	self assert: transformedNode initialValue equals: initialValue.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMacroMessageDefinitionNode [
	| returnType definition body transformedNode |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder macroMessageSelector: #zero arguments: #() returnType: returnType definitionBody: body.
	transformedNode := visitor visitNode: definition.
	self assert: transformedNode ~~ definition.
	self assert: transformedNode prototype ~~ definition prototype.
	self assert: transformedNode isMacroMessageMethodDefinitionNode.
	self assert: transformedNode prototype isMacroMessageMethodPrototypeNode.
	self assert: transformedNode selector equals: #zero.
	self assert: transformedNode arguments equals: #().
	self assert: transformedNode returnType equals: returnType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMacroMessagePrototypeNode [
	| arguments prototype transformedNode |
	arguments := { 
		builder argument: #x type: nil.
		builder argument: #y type: nil.
	}.
	prototype := builder macroMessagePrototypeSelector: #+ arguments: arguments returnType: nil.
	transformedNode := visitor visitNode: prototype.
	self assert: transformedNode ~~ prototype.
	self assert: transformedNode isMacroMessageMethodPrototypeNode.
	self assert: transformedNode selector equals: prototype selector.

	self assert: transformedNode arguments first ~~ arguments first.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode arguments first type equals: nil.

	self assert: transformedNode arguments second ~~ arguments second.
	self assert: transformedNode arguments second name equals: arguments second name.
	self assert: transformedNode arguments second type equals: nil.

	self assert: transformedNode returnType equals: nil.
	
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMatrixConstructionNode [
	| node zero one firstColumn secondColumn transformedNode |
	zero := builder literalInteger: 0.
	one := builder literalInteger: 1.
	firstColumn := builder identifier: #firstColumn.
	secondColumn := builder identifier: #secondColumn.
	node := builder constructMatrix: (builder identifier: #Float32x2x2) withColumns: {firstColumn . secondColumn}.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isMatrixConstructionNode.
	self assert: transformedNode columns equals: {firstColumn . secondColumn}.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMatrixGetColumnNode [
	| node matrix transformedNode |
	matrix := builder identifier: #x.
	node := builder matrix: matrix getColumn: (builder literalInteger: 1).
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isMatrixGetColumnNode.
	self deny: transformedNode isMatrixGetRowNode.
	self assert: transformedNode matrix equals: matrix.
	self assert: transformedNode element value equals: 1.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMatrixGetRowNode [
	| node matrix transformedNode |
	matrix := builder identifier: #x.
	node := builder matrix: matrix getRow: (builder literalInteger: 1).
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isMatrixGetRowNode.
	self deny: transformedNode isMatrixGetColumnNode.
	self assert: transformedNode matrix equals: matrix.
	self assert: transformedNode element value equals: 1.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMatrixMultiplicationOperationNode [
	| node leftMatrix rightMatrix transformedNode |
	leftMatrix := builder identifier: #leftMatrix.
	rightMatrix := builder identifier: #rightMatrix.
	node := builder matrix: leftMatrix multiplicationWith: rightMatrix.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isMatrixMultiplicationOperationNode.
	self assert: transformedNode leftMatrix equals: leftMatrix.
	self assert: transformedNode rightMatrix equals: rightMatrix.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMatrixSetColumnValueNode [
	| node matrix value transformedNode |
	matrix := builder identifier: #x.
	value := builder identifier: #y.
	node := builder matrix: matrix setColumn: (builder literalInteger: 1) value: value.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isMatrixSetColumnValueNode.
	self deny: transformedNode isMatrixSetRowValueNode.
	self assert: transformedNode matrix equals: matrix.
	self assert: transformedNode element value equals: 1.
	self assert: transformedNode value equals: value.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMatrixSetRowValueNode [
	| node matrix value transformedNode |
	matrix := builder identifier: #x.
	value := builder identifier: #y.
	node := builder matrix: matrix setRow: (builder literalInteger: 1) value: value.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isMatrixSetRowValueNode.
	self deny: transformedNode isMatrixSetColumnValueNode.
	self assert: transformedNode matrix equals: matrix.
	self assert: transformedNode element value equals: 1.
	self assert: transformedNode value equals: value.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessageChainMessageNode [
	| node transformedNode selector arguments |
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	node := builder messageChainMessageSelector: selector arguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessageChainNode [
	| node transformedNode selector arguments receiver chainedMessage |
	receiver := builder literalInteger: -1.
	
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	chainedMessage := builder messageChainMessageSelector: selector arguments: arguments.
	node := builder messageChainReceiver: receiver messages: { chainedMessage }.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode receiver equals: receiver.
	self assert: transformedNode messages first selector equals: chainedMessage selector.
	self assert: transformedNode messages first arguments equals: chainedMessage arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessageDefinitionNode [
	| returnType definition body transformedNode |
	returnType := builder identifier: #Int32.
	body := builder literalInteger: 0.
	definition := builder messageSelector: #zero arguments: #() returnType: returnType definitionBody: body.
	transformedNode := visitor visitNode: definition.
	self assert: transformedNode ~~ definition.
	self assert: transformedNode prototype ~~ definition prototype.
	self assert: transformedNode isMessageMethodDefinitionNode.
	self assert: transformedNode prototype isMessageMethodPrototypeNode.
	self assert: transformedNode selector equals: #zero.
	self assert: transformedNode arguments equals: #().
	self assert: transformedNode returnType equals: returnType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMessagePrototypeNode [
	| arguments returnType prototype transformedNode |
	arguments := { 
		builder argument: #x type: (builder identifier: #Int32).
		builder argument: #y type: (builder identifier: #Int32).
	}.
	returnType := (builder identifier: #Int32).
	prototype := builder messagePrototypeSelector: #+ arguments: arguments returnType: returnType.
	transformedNode := visitor visitNode: prototype.
	self assert: transformedNode ~~ prototype.
	self assert: transformedNode isMessageMethodPrototypeNode.
	self assert: transformedNode selector equals: prototype selector.

	self assert: transformedNode arguments first ~~ arguments first.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode arguments first type equals: arguments first type.

	self assert: transformedNode arguments second ~~ arguments second.
	self assert: transformedNode arguments second name equals: arguments second name.
	self assert: transformedNode arguments second type equals: arguments second type.

	self assert: transformedNode returnType equals: returnType.
	
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testMetaBuilderInstanceNode [
	| node transformedNode |
	node := MbndAstMetaBuilderInstanceNode new instance: 42.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode == node.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testNamespaceDefinition [
	| node transformedNode body |
	body := builder literalInteger: 42.
	node := builder namespace: #HelloNamespace definition: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isNamespaceDefinitionNode.
	self assert: transformedNode name equals: #HelloNamespace.
	self assert: transformedNode body equals: body.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testPointerAsReference [
	| node pointer transformedNode |
	pointer := builder identifier: #x.
	node := builder pointerAsReference: pointer.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isPointerAsReferenceNode.
	self assert: transformedNode pointer equals: pointer.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testPointerElementReferenceNode [
	| node pointer index transformedNode |
	pointer := builder identifier: #tr.
	index := builder literalInteger: 42.
	node := builder pointer: pointer elementReferenceAt: index.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isPointerElementReferenceNode.
	self assert: transformedNode container equals: pointer.
	self assert: transformedNode index equals: index.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testPragmaNode [
	| node transformedNode selector arguments |
	selector := #somePragma:withArg:.
	arguments := { 
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmaSelector: selector arguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testProgramEntityExtensionNode [
	| node transformedNode programEntity extension |
	programEntity := builder identifier: #ProgramEntity.
	extension := builder sequence: #().
	node := builder programEntity: programEntity extension: extension.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isProgramEntityExtensionNode.
	self assert: transformedNode programEntity equals: programEntity.
	self assert: transformedNode body isSequenceNode.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testQuasiQuoteNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder quasiQuote: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testQuasiUnquoteNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder quasiUnquote: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testQuoteNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder quote: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testReferenceAsPointer [
	| node reference transformedNode |
	reference := builder identifier: #x.
	node := builder referenceAsPointer: reference.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isReferenceAsPointerNode.
	self assert: transformedNode reference equals: reference.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testReferenceLoad [
	| node reference transformedNode |
	reference := builder identifier: #x.
	node := builder referenceLoad: reference.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isReferenceLoadNode.
	self assert: transformedNode reference equals: reference.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testReinterpretCast [
	| node value targetType transformedNode |
	value := builder literalInteger: 42.
	targetType := builder identifier: #Float32.
	node := builder reinterpretCast: value to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isReinterpretCastNode.
	self assert: transformedNode expression equals: value.
	self assert: transformedNode targetType equals: targetType.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testReturnStatementNode [
	| node transformedNode pragmaNode elements |
	pragmaNode := builder pragmaSelector: #pragma:withArg arguments: {
		builder literalInteger: -1.
		builder literalInteger: -2.
	}.
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmas: { pragmaNode } sequence: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode pragmas first selector equals: pragmaNode selector.
	self assert: transformedNode pragmas first arguments equals: pragmaNode arguments.
	self assert: transformedNode elements equals: elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSampleTextureWithExplicitDerivatives [
	| node sampler texture texcoord dtdx dtdy tranformedNode |
	sampler := builder identifier: #sampler.
	texture := builder identifier: #texture.
	texcoord := builder identifier: #texcoord.
	dtdx := builder identifier: #dtdx.
	dtdy := builder identifier: #dtdy.
	node := builder sampleWith: sampler texture: texture at: texcoord dtdx: dtdx dtdy: dtdy.
	tranformedNode := visitor visitNode: node.
	self assert: node ~~ tranformedNode.
	self assert: tranformedNode isSampleTextureWithExplicitDerivativesNode.
	self assert: tranformedNode sampler equals: sampler.
	self assert: tranformedNode texture equals: texture.
	self assert: tranformedNode texcoord equals: texcoord.
	self assert: tranformedNode dtdx equals: dtdx.
	self assert: tranformedNode dtdy equals: dtdy.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSampleTextureWithExplicitLod [
	| node sampler texture texcoord lod transformedNode |
	sampler := builder identifier: #sampler.
	texture := builder identifier: #texture.
	texcoord := builder identifier: #texcoord.
	lod := builder identifier: #lod.
	node := builder sampleWith: sampler texture: texture at: texcoord lod: lod.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isSampleTextureWithExplicitLodNode.
	self assert: transformedNode sampler equals: sampler.
	self assert: transformedNode texture equals: texture.
	self assert: transformedNode texcoord equals: texcoord.
	self assert: transformedNode lod equals: lod.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSampleTextureWithImplicitLod [
	| node sampler texture texcoord transformedNode |
	sampler := builder identifier: #sampler.
	texture := builder identifier: #texture.
	texcoord := builder identifier: #texcoord.
	node := builder sampleWith: sampler texture: texture atWithImplicitLod: texcoord.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isSampleTextureWithImplicitLodNode.
	self assert: transformedNode sampler equals: sampler.
	self assert: transformedNode texture equals: texture.
	self assert: transformedNode texcoord equals: texcoord.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSequenceNode [
	| node transformedNode pragmaNode elements |
	pragmaNode := builder pragmaSelector: #pragma:withArg arguments: {
		builder literalInteger: -1.
		builder literalInteger: -2.
	}.
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder pragmas: { pragmaNode } sequence: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode pragmas first selector equals: pragmaNode selector.
	self assert: transformedNode pragmas first arguments equals: pragmaNode arguments.
	self assert: transformedNode elements equals: elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSignExtensionCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder signExtend: expression to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isSignExtensionCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testSpliceNode [
	| node transformedNode expression |
	expression := builder literalInteger: 1.
	node := builder splice: expression.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode expression equals: expression.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testStructureDeclarationNode [
	| node transformedNode |
	node := builder declareStructure: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isStructureDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testStructureDefinitionNode [
	| node body transformedNode |
	body := builder sequence: #().
	node := builder defineStructureNamed: #Test body: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isStructureDefinitionNode.
	self assert: transformedNode declaration isStructureDeclarationNode.
	self assert: transformedNode declaration name equals: #Test.
	self assert: transformedNode body elements equals: body elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testTemplateDefinition [
	| arguments body node transformedNode |
	arguments := {
		builder argument: #T type: (builder identifier: #Type).
	}.
	body := builder defineStructureNamed: #_ body: ( 
		builder defineField: #value withValueType: (builder identifier: #T) withInitialValue: nil
	).
	node := builder defineTemplate: #ValueHolder arguments: arguments body: body.
	transformedNode := visitor visitNode: node.
	
	self assert: node ~~ transformedNode.
	self assert: transformedNode isTemplateDefinitionNode.
	self assert: transformedNode name equals: #ValueHolder.
	self assert: transformedNode arguments first name equals: arguments first name.
	self assert: transformedNode body isStructureDefinitionNode.

]

{ #category : #tests }
MbndAstTransformVisitorTest >> testTraitDeclarationNode [
	| node transformedNode |
	node := builder declareTrait: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isTraitDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testTraitDefinitionNode [
	| node body transformedNode |
	body := builder sequence: #().
	node := builder defineTraitNamed: #Test body: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isTraitDefinitionNode.
	self assert: transformedNode declaration isTraitDeclarationNode.
	self assert: transformedNode declaration name equals: #Test.
	self assert: transformedNode body elements equals: body elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testTruncateCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder truncate: expression to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isTruncateCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testTupleElementReferenceNode [
	| node tuple index transformedNode |
	tuple := builder identifier: #tr.
	index := builder literalInteger: 42.
	node := builder tuple: tuple elementReferenceAt: index.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isTupleElementReferenceNode.
	self assert: transformedNode container equals: tuple.
	self assert: transformedNode index equals: index.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testTupleNode [
	| node transformedNode elements |
	elements := {
		builder literalInteger: 1.
		builder literalInteger: 2.
	}.
	
	node := builder tuple: elements.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode elements equals: elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testUnexpandedMessageSendNode [
	| node transformedNode receiver selector arguments |
	receiver := builder literalInteger: 1.
	selector := builder literalSymbol: #to:by:.
	arguments := {
		builder literalInteger: 2.
		builder literalInteger: 3.
	}.
	
	node := builder send: selector to: receiver withArguments: arguments.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode receiver equals: node receiver.
	self assert: transformedNode selector equals: node selector.
	self assert: transformedNode arguments equals: node arguments.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testUnionDeclarationNode [
	| node transformedNode |
	node := builder declareUnion: #Test.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isUnionDeclarationNode.
	self assert: transformedNode name equals: node name.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testUnionDefinitionNode [
	| node body transformedNode |
	body := builder sequence: #().
	node := builder defineUnionNamed: #Test body: body.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode isUnionDefinitionNode.
	self assert: transformedNode declaration isUnionDeclarationNode.
	self assert: transformedNode declaration name equals: #Test.
	self assert: transformedNode body elements equals: body elements.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testVariableReference [
	| node transformedNode dummyBinding |
	dummyBinding := MbndFunctionLocalVariable new
		valueType: module compilationTarget int32Type;
		type: module compilationTarget int32Type ref;
		yourself.
	node := builder variableReference: dummyBinding.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode binding equals: node binding.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testVectorConstructionNode [
	| node one two vectorType transformedNode |
	one := builder literalInteger: 1.
	two := builder literalInteger: 2.
	vectorType := builder identifier: #Float32x4.
	node := builder constructVector: vectorType withElements: { one . two }.
	transformedNode := visitor visitNode: node.
	
	self assert: node ~~ transformedNode.
	self assert: transformedNode isVectorConstructionNode.
	self assert: transformedNode vectorType equals: vectorType.
	self assert: transformedNode elements equals: {one . two}.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testVectorGetElementNode [
	| node vector transformedNode |
	vector := builder identifier: #x.
	node := builder vector: vector getElement: 2.
	transformedNode := visitor visitNode: node.
	self assert: node ~~ transformedNode.
	self assert: transformedNode isVectorGetElementsNode.
	self assert: transformedNode vector equals: vector.
	self assert: transformedNode elements equals: #(2).
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testVectorSetElementsNode [
	| node vector elements values transformedNode |
	vector := builder identifier: #x.
	elements := #(1 2).
	values := { builder literalInteger: 42 . builder literalInteger: 13}.
	node := builder vector: vector setElements: elements values: values.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isVectorSetElementsNode.
	self assert: transformedNode vector equals: vector.
	self assert: transformedNode elements equals: elements.
	self assert: transformedNode values equals: values.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testWhileLoopNode [
	| node transformedNode condition action continueAction |
	condition := builder identifier: #predicate.
	action := builder literalInteger: 42.
	continueAction := builder literalInteger: 1.

	node := builder while: condition do: action continueWith: continueAction.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode condition equals: node condition.
	self assert: transformedNode action equals: node action.
	self assert: transformedNode continueAction equals: node continueAction.
]

{ #category : #tests }
MbndAstTransformVisitorTest >> testZeroExtensionCastNode [
	| expression node targetType transformedNode |
	expression := builder identifier: #x.
	targetType := builder identifier: #Int32.
	node := builder zeroExtend: expression to: targetType.
	transformedNode := visitor visitNode: node.
	self assert: transformedNode ~~ node.
	self assert: transformedNode isZeroExtensionCastNode.
	self assert: transformedNode expression equals: expression.
	self assert: transformedNode targetType equals: targetType.
]
