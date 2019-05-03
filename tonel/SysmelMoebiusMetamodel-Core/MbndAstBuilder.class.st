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
	^ MbndAstCompileTimeConstantDefinitionNode new
		name: name;
		value: value;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> argument: name type: valueType [
	^ MbndAstArgumentDefinitionNode new
		name: name;
		valueType: valueType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> array: array elementReferenceAt: index [
	^ MbndAstArrayElementReferenceNode new
		container: array;
		index: index;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> breakStatement [
	^ MbndAstBreakStatementNode new
]

{ #category : #'builder methods' }
MbndAstBuilder >> call: function arguments: arguments [
	^ MbndAstFunctionCallNode new
		function: function;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> casesOf: matchedExpression cases: cases [
	^ MbndAstCasesOfNode new
		matchedExpression: matchedExpression;
		cases: cases;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> casesOfCase: pattern do: action [
	^ MbndAstCasesOfCaseNode new
		pattern: pattern;
		action: action;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> casesOfDefaultCaseDo: action [
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
	^ MbndAstContinueStatementNode new
]

{ #category : #'builder methods' }
MbndAstBuilder >> defineLocalVariable: name withValueType: valueType withInitialValue: initialValue [
	^ MbndAstLocalVariableDefinitionNode new
		name: name;
		valueType: valueType;
		initialValue: initialValue;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> do: action while: condition [
	^ MbndAstDoWhileLoopNode new
		action: action;
		condition: condition;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> explicitCast: expression to: targetType [
	^ MbndAstExplicitCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> functionNamed: name arguments: arguments returnType: returnType definitionBody: definitionBody [
	^ self functionPrototype: (self functionPrototypeNamed: name arguments: arguments returnType: returnType) definitionBody: definitionBody
]

{ #category : #'builder methods' }
MbndAstBuilder >> functionPrototype: prototype definitionBody: definitionBody [
	^ MbndAstFunctionDefinitionNode new
		prototype: prototype;
		body: definitionBody;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> functionPrototypeNamed: name arguments: arguments returnType: returnType [
	^ MbndAstFunctionPrototypeNode new
		name: name;
		arguments: arguments;
		returnType: returnType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> identifier: symbol [
	^ MbndAstIdentifierReferenceNode new symbol: symbol
]

{ #category : #'builder methods' }
MbndAstBuilder >> if: condition trueValue: trueValue falseValue: falseValue [
	^ MbndAstIfConditionNode new
		condition: condition;
		trueValue: trueValue;
		falseValue: falseValue;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> implicitCast: expression to: targetType [
	^ MbndAstImplicitCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> lexicalScope: expression [
	^ MbndAstLexicalScopeNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> literal: literalValue type: type [
	^ MbndAstLiteralValueNode new
		value: literalValue;
		type: type;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> literal: literalValue typeName: typeSelector [
	^ MbndAstLiteralValueNode new
		value: literalValue;
		type: (self lookupTypeWithName: typeSelector);
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalBoolean: literalValue [
	^ literalValue
		ifTrue: [ self literalBooleanTrue ]
		ifFalse: [ self literalBooleanFalse ]
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalBooleanFalse [
	^ self literal: false typeName: #_LiteralBooleanFalse
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalBooleanTrue [
	^ self literal: true typeName: #_LiteralBooleanTrue
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalFloat: literalValue [
	^ self literal: literalValue typeName: #_LiteralFloat
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalInteger: literalValue [
	^ self literal: literalValue typeName: #_LiteralInteger
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalString: literalValue [
	^ self literal: literalValue typeName: #_LiteralString
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalSymbol: literalValue [
	^ self literal: literalValue typeName: #_LiteralSymbol
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalUndefined [
	^ self literal: nil typeName: MbndUndefinedType typeName
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalVoid [
	^ self literal: nil typeName: MbndVoidType typeName
]

{ #category : #'builder methods' }
MbndAstBuilder >> lookupTypeWithName: typeSelector [
	^ self compilationTarget lookupTypeWithName: typeSelector
]

{ #category : #'builder methods' }
MbndAstBuilder >> messageChainMessageSelector: selector arguments: arguments [
	^ MbndAstMessageChainMessageNode new
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messageChainReceiver: receiver messages: chainedMessages [
	^ MbndAstMessageChainNode new
		receiver: receiver;
		messages: chainedMessages;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messagePrototype: prototype definitionBody: definitionBody [
	^ MbndAstMessageDefinitionNode new
		prototype: prototype;
		body: definitionBody;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messagePrototypeSelector: selector arguments: arguments returnType: returnType [
	^ MbndAstMessagePrototypeNode new
		selector: selector;
		arguments: arguments;
		returnType: returnType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> messageSelector: selector arguments: arguments returnType: returnType definitionBody: definitionBody [
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
	^ MbndAstNamespaceDefinitionNode new
		name: name;
		body: body;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pointer: pointer elementReferenceAt: index [
	^ MbndAstPointerElementReferenceNode new
		container: pointer;
		index: index;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pragmaSelector: selector arguments: arguments [
	^ MbndAstPragmaNode new
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> pragmas: aSequenceOfPragmas sequence: aSequenceOfNodes [
	^ MbndAstSequenceNode new
		pragmas: aSequenceOfPragmas;
		elements: aSequenceOfNodes;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> quasiQuote: expression [
	^ MbndAstQuasiQuoteNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> quasiUnquote: expression [
	^ MbndAstQuasiUnquoteNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> quote: expression [
	^ MbndAstQuoteNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> reference: reference assignValue: value [
	^ MbndAstAssignmentNode new
		reference: reference;
		value: value;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> referenceLoad: reference [
	^ MbndAstReferenceLoadNode new
		reference: reference;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> reinterpretCast: expression to: targetType [
	^ MbndAstReinterpretCastNode new
		expression: expression;
		targetType: targetType;
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> return: expression [
	^ MbndAstReturnStatementNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> send: selector to: aReceiver withArguments: arguments [
	<compileTime>
	^ MbndAstExpandedMessageSendNode new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
MbndAstBuilder >> sequence: aSequenceOfNodes [
	^ self pragmas: #() sequence: aSequenceOfNodes
]

{ #category : #'builder methods' }
MbndAstBuilder >> splice: expression [
	^ MbndAstSpliceNode new expression: expression
]

{ #category : #'builder methods' }
MbndAstBuilder >> tuple: aSequenceOfNodes [
	^ MbndAstTupleNode new elements: aSequenceOfNodes; yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> unexpandedSend: selector to: aReceiver withArguments: arguments [
	<compileTime>
	^ MbndAstUnexpandedMessageSendNode new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
MbndAstBuilder >> variableReference: binding [
	^ MbndAstVariableReference new binding: binding
]

{ #category : #'builder methods' }
MbndAstBuilder >> while: condition do: action [
	^ self while: condition do: action continueWith: nil
]

{ #category : #'builder methods' }
MbndAstBuilder >> while: condition do: action continueWith: continueAction [
	^ MbndAstWhileLoopNode new
		condition: condition;
		action: action;
		continueAction: continueAction;
		yourself
]
