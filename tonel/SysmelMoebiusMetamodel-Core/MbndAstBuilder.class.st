Class {
	#name : #MbndAstBuilder,
	#superclass : #Object,
	#instVars : [
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstBuilder class >> forModule: aModule [
	^ self new module: aModule; yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> alias: name definition: value [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstCompileTimeConstantDefinitionNode new
		name: name;
		value: value;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> argument: name type: valueType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstArgumentDefinitionNode new
		name: name;
		valueType: valueType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> array: array elementReferenceAt: index [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstArrayElementReferenceNode new
		container: array;
		index: index;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> bitCast: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstBitCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> breakStatement [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstBreakStatementNode new
]

{ #category : #'builder methods' }
MbndAstBuilder >> call: function arguments: arguments [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstFunctionCallNode new
		function: function;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> casesOf: matchedExpression cases: cases [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstCasesOfNode new
		matchedExpression: matchedExpression;
		cases: cases;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> casesOfCase: pattern do: action [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstCasesOfCaseNode new
		pattern: pattern;
		action: action;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> casesOfDefaultCaseDo: action [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstCasesOfDefaultCaseNode new
		action: action;
		yourself
]

{ #category : #accessing }
MbndAstBuilder >> compilationTarget [
	^ module compilationTarget
]

{ #category : #'builder methods' }
MbndAstBuilder >> continueStatement [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstContinueStatementNode new
]

{ #category : #'builder methods' }
MbndAstBuilder >> declareClass: name [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstClassDeclarationNode new
		name: name;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> declareGCClass: name [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstGCClassDeclarationNode new
		name: name;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> declareStructure: name [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstStructureDeclarationNode new
		name: name;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> declareUnion: name [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstUnionDeclarationNode new
		name: name;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineClass: declaration superclass: superclass body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstClassDefinitionNode new
		declaration: declaration;
		superclass: superclass;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineClassNamed: name superclass: superclass body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ self defineClass: (self declareClass: name) superclass: superclass body: body
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineField: name withValueType: valueType withInitialValue: initialValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstFieldDefinitionNode new
		name: name;
		valueType: valueType;
		initialValue: initialValue;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineGCClass: declaration superclass: superclass body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstGCClassDefinitionNode new
		declaration: declaration;
		superclass: superclass;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineGCClassNamed: name superclass: superclass body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ self defineGCClass: (self declareGCClass: name) superclass: superclass body: body
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineLocalVariable: name withValueType: valueType withInitialValue: initialValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstLocalVariableDefinitionNode new
		name: name;
		valueType: valueType;
		initialValue: initialValue;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineStructure: declaration body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstStructureDefinitionNode new
		declaration: declaration;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineStructureNamed: name body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ self defineStructure: (self declareStructure: name) body: body
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineTemplate: name arguments: arguments body: body [
	<compileTime>
	^ MbndAstTemplateDefinitionNode new
		name: name;
		arguments: arguments;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineUnion: declaration body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstUnionDefinitionNode new
		declaration: declaration;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineUnionNamed: name body: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ self defineUnion: (self declareUnion: name) body: body
]

{ #category : #'builder methods' }
MbndAstBuilder >> do: action continueWith: continueAction while: condition [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstDoWhileLoopNode new
		action: action;
		continueAction: continueAction;
		condition: condition;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> do: action while: condition [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstDoWhileLoopNode new
		action: action;
		condition: condition;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> explicitCast: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstExplicitCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> floatingPoint: expression toInteger: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstFloatingPointToIntegerCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> floatingPointSize: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstFloatingPointSizeCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> functionNamed: name arguments: arguments returnType: returnType definitionBody: definitionBody [
	<compileTime>
	<returnType: #_ASTNode>
	^ self functionPrototype: (self functionPrototypeNamed: name arguments: arguments returnType: returnType) definitionBody: definitionBody
]

{ #category : #'builder methods' }
MbndAstBuilder >> functionPrototype: prototype definitionBody: definitionBody [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstFunctionDefinitionNode new
		prototype: prototype;
		body: definitionBody;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> functionPrototypeNamed: name arguments: arguments returnType: returnType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstFunctionPrototypeNode new
		name: name;
		arguments: arguments;
		returnType: returnType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> getAggregate: aggregate referenceOfField: field [
	<compileTime>
	^ MbndAstGetFieldReferenceNode new
		aggregate: aggregate;
		field: field;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> getAggregate: aggregate valueOfField: field [
	<compileTime>
	^ MbndAstGetFieldValueNode new
		aggregate: aggregate;
		field: field;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> identifier: symbol [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstIdentifierReferenceNode new symbol: symbol
]

{ #category : #'builder methods' }
MbndAstBuilder >> if: condition trueValue: trueValue falseValue: falseValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstIfConditionNode new
		condition: condition;
		trueValue: trueValue;
		falseValue: falseValue;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> implicitCast: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstImplicitCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> integer: expression toFloatingPoint: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstIntegerToFloatingPointCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> lexicalScope: expression [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstLexicalScopeNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> literal: literalValue type: type [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstLiteralValueNode new
		value: literalValue;
		type: type;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> literal: literalValue typeName: typeSelector [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstLiteralValueNode new
		value: literalValue;
		type: (self lookupTypeWithName: typeSelector);
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalBoolean: literalValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ literalValue
		ifTrue: [ self literalBooleanTrue ]
		ifFalse: [ self literalBooleanFalse ]
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalBooleanFalse [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: false typeName: #_LiteralBooleanFalse
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalBooleanTrue [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: true typeName: #_LiteralBooleanTrue
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalFloat: literalValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: literalValue typeName: #_LiteralFloat
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalInteger: literalValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: literalValue typeName: #_LiteralInteger
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalString: literalValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: literalValue typeName: #_LiteralString
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalSymbol: literalValue [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: literalValue typeName: #_LiteralSymbol
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalUndefined [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: nil typeName: MbndUndefinedType typeName
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalVoid [
	<compileTime>
	<returnType: #_ASTNode>
	^ self literal: nil typeName: MbndVoidType typeName
]

{ #category : #'builder methods' }
MbndAstBuilder >> lookupTypeWithName: typeSelector [
	<compileTime>
	<returnType: #_ASTNode>
	^ self compilationTarget lookupTypeWithName: typeSelector
]

{ #category : #'builder methods' }
MbndAstBuilder >> macroMessagePrototype: prototype definitionBody: definitionBody [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstMacroMessageDefinitionNode new
		prototype: prototype;
		body: definitionBody;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> macroMessagePrototypeSelector: selector arguments: arguments returnType: returnType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstMacroMessagePrototypeNode new
		selector: selector;
		arguments: arguments;
		returnType: returnType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> macroMessageSelector: selector arguments: arguments returnType: returnType definitionBody: definitionBody [
	<compileTime>
	<returnType: #_ASTNode>
	^ self macroMessagePrototype: (self macroMessagePrototypeSelector: selector arguments: arguments returnType: returnType)
		definitionBody: definitionBody
]

{ #category : #'builder methods' }
MbndAstBuilder >> messageChainMessageSelector: selector arguments: arguments [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstMessageChainMessageNode new
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messageChainReceiver: receiver messages: chainedMessages [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstMessageChainNode new
		receiver: receiver;
		messages: chainedMessages;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messagePrototype: prototype definitionBody: definitionBody [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstMessageDefinitionNode new
		prototype: prototype;
		body: definitionBody;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messagePrototypeSelector: selector arguments: arguments returnType: returnType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstMessagePrototypeNode new
		selector: selector;
		arguments: arguments;
		returnType: returnType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messageSelector: selector arguments: arguments returnType: returnType definitionBody: definitionBody [
	<compileTime>
	<returnType: #_ASTNode>
	^ self messagePrototype: (self messagePrototypeSelector: selector arguments: arguments returnType: returnType)
		definitionBody: definitionBody
]

{ #category : #accessing }
MbndAstBuilder >> module [
	^ module
]

{ #category : #accessing }
MbndAstBuilder >> module: aModule [
	module := aModule
]

{ #category : #'builder methods' }
MbndAstBuilder >> namespace: name definition: body [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstNamespaceDefinitionNode new
		name: name;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pointer: pointer elementReferenceAt: index [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstPointerElementReferenceNode new
		container: pointer;
		index: index;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pointerAsReference: pointer [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstPointerAsReferenceNode new
		pointer: pointer;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pragmaSelector: selector arguments: arguments [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstPragmaNode new
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pragmas: aSequenceOfPragmas sequence: aSequenceOfNodes [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstSequenceNode new
		pragmas: aSequenceOfPragmas;
		elements: aSequenceOfNodes;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> quasiQuote: expression [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstQuasiQuoteNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> quasiUnquote: expression [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstQuasiUnquoteNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> quote: expression [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstQuoteNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> reference: reference assignValue: value [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstAssignmentNode new
		reference: reference;
		value: value;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> referenceAsPointer: reference [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstReferenceAsPointerNode new
		reference: reference;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> referenceLoad: reference [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstReferenceLoadNode new
		reference: reference;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> reinterpretCast: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstReinterpretCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> return: expression [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstReturnStatementNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> send: selector to: aReceiver withArguments: arguments [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstExpandedMessageSendNode new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
MbndAstBuilder >> sequence: aSequenceOfNodes [
	<compileTime>
	<returnType: #_ASTNode>
	^ self pragmas: #() sequence: aSequenceOfNodes
]

{ #category : #'builder methods' }
MbndAstBuilder >> setAggregate: aggregate field: field value: newValue [
	<compileTime>
	^ MbndAstSetFieldValueNode new
		aggregate: aggregate;
		field: field;
		newValue: newValue;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> signExtend: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstSignExtensionCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> splice: expression [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstSpliceNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> truncate: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstTruncateCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> tuple: aSequenceOfNodes [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstTupleNode new elements: aSequenceOfNodes; yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> unexpandedCall: calledFunction withArguments: aCollectionOfArguments [
	<compileTime>
	<returnType: #_ASTNode>
	^ self unexpandedSend: (self literalSymbol: #applyWithArguments:) to: calledFunction withArguments: { 		self tuple: aCollectionOfArguments
	}
]

{ #category : #'builder methods' }
MbndAstBuilder >> unexpandedSend: selector to: aReceiver withArguments: arguments [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstUnexpandedMessageSendNode new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
MbndAstBuilder >> variableReference: binding [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstVariableReference new binding: binding
]

{ #category : #'builder methods' }
MbndAstBuilder >> while: condition do: action [
	<compileTime>
	<returnType: #_ASTNode>
	^ self while: condition do: action continueWith: nil
]

{ #category : #'builder methods' }
MbndAstBuilder >> while: condition do: action continueWith: continueAction [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstWhileLoopNode new
		condition: condition;
		action: action;
		continueAction: continueAction;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> zeroExtend: expression to: targetType [
	<compileTime>
	<returnType: #_ASTNode>
	^ MbndAstZeroExtensionCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]
