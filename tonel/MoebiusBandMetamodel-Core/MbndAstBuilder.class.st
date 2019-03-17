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
MbndAstBuilder >> literal: literalValue typeName: typeSelector [
	^ MbndAstLiteralValueNode new
		value: literalValue;
		type: (self lookupTypeWithName: typeSelector);
		yourself
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
MbndAstBuilder >> send: selector to: aReceiver withArguments: arguments [
	<compileTime>
	^ MbndAstExpandedMessageSendNode new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
MbndAstBuilder >> sequence: aCollectionOfNodes [
	^ MbndAstSequenceNode new elements: aCollectionOfNodes
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
