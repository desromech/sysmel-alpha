Class {
	#name : #MbndAstBuilder,
	#superclass : #Object,
	#instVars : [
		'module'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstBuilder class >> forModule: aModule [
	^ self new module: aModule; yourself
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
MbndAstBuilder >> do: action while: condition [
	^ MbndAstDoWhileLoopNode new
		action: action;
		condition: condition;
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
MbndAstBuilder >> lexicalScope: expression [
	^ MbndAstLexicalScopeNode new expression: expression
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

{ #category : #accessing }
MbndAstBuilder >> module [
	^ module
]

{ #category : #accessing }
MbndAstBuilder >> module: aModule [
	module := aModule
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
MbndAstBuilder >> unexpandedSend: selector to: aReceiver withArguments: arguments [
	<compileTime>
	^ MbndAstUnexpandedMessageSendNode new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
MbndAstBuilder >> while: condition do: action [
	^ MbndAstWhileLoopNode new
		condition: condition;
		action: action;
		yourself
]
