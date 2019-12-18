"
A MbndPharoDoItLanguageTest is a test class for testing the behavior of MbndPharoDoItLanguage
"
Class {
	#name : #MbndPharoLanguageTest,
	#superclass : #TestCase,
	#instVars : [
		'module'
	],
	#category : #'SysmelLanguage-Pharo-Tests'
}

{ #category : #running }
MbndPharoLanguageTest >> evaluateSource: aString [
	^ module evaluateLanguage: self languageName source: aString
]

{ #category : #running }
MbndPharoLanguageTest >> languageName [
	^ #pharo
]

{ #category : #running }
MbndPharoLanguageTest >> parseSource: aString [
	^ (module parseLanguage: self languageName source: aString) ast
]

{ #category : #running }
MbndPharoLanguageTest >> setUp [
	module := MbndDummyModule new
]

{ #category : #tests }
MbndPharoLanguageTest >> testArithmeticEvaluation [
	self assert: (self evaluateSource: '1+1') unwrapMbndValue equals: 2.
	self assert: (self evaluateSource: '1.5 floor') unwrapMbndValue equals: 1.
	self assert: (self evaluateSource: '4.0 sqrt') unwrapMbndValue equals: 2.
]

{ #category : #tests }
MbndPharoLanguageTest >> testAssignmentParsing [
	| node |
	node := self parseSource: 'x := 42'.
	self assert: node isUnexpandedMessageSendNode.
	self assert: node selector isLiteralValueNode.
	self assert: node selector type isLiteralSymbolType.
	self assert: node selector value equals: #assignValue:.
	self assert: node arguments size equals: 1.
	
	self assert: node arguments first isLiteralValueNode.
	self assert: node arguments first type isLiteralIntegerType.
	self assert: node arguments first value equals: 42.
]

{ #category : #tests }
MbndPharoLanguageTest >> testBlockClosureParsing [
	| node |
	node := self parseSource: '[:x :y | x ]'.
	self assert: node isBlockClosureNode.
	self assert: node arguments size equals: 2.
	self assert: node arguments first name equals: #x.
	self assert: node arguments second name equals: #y.
	self assert: node returnType equals: nil .
	
	self assert: node body isLexicalScopeNode.
	self assert: node body expression isSequenceNode.
	self assert: node body expression elements size equals: 1.
	self assert: node body expression elements first isIdentifierReferenceNode.
	self assert: node body expression elements first symbol equals: #x.

]

{ #category : #tests }
MbndPharoLanguageTest >> testIdentifierParsing [
	| node |
	node := self parseSource: 'someVar'.
	self assert: node isIdentifierReferenceNode.
	self assert: node symbol equals: #someVar.

]

{ #category : #tests }
MbndPharoLanguageTest >> testLiteralEvaluation [
	| result |
	result := self evaluateSource: 'true'.
	self assert: result value equals: true.
	self assert: result type isLiteralBooleanTrueType.

	result := self evaluateSource: 'false'.
	self assert: result value equals: false.
	self assert: result type isLiteralBooleanFalseType.

	result := self evaluateSource: 'nil'.
	self assert: result value equals: nil.
	self assert: result type isUndefinedType.

	result := self evaluateSource: '1'.
	self assert: result value equals: 1.
	self assert: result type isLiteralIntegerType.

	result := self evaluateSource: '2.5'.	
	self assert: result value equals: 2.5.
	self assert: result type isLiteralFloatType.

	result := self evaluateSource: '''Test String'''.	
	self assert: result value equals: 'Test String'.
	self assert: result type isLiteralStringType.
		
	result := self evaluateSource: '#testSymbol:'.
	self assert: result value equals: #testSymbol:.
	self assert: result type isLiteralSymbolType.

	result := self evaluateSource: '#(1 2 3)'.
	self assert: result value equals: #(1 2 3).
	self assert: result type isLiteralArrayType.
	
	result := self evaluateSource: '#[1 2 3]'.
	self assert: result value equals: #[1 2 3].
	self assert: result type isLiteralByteArrayType.

]

{ #category : #tests }
MbndPharoLanguageTest >> testLiteralParsing [
	| node |
	node := self parseSource: 'true'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: true.
	self assert: node type isLiteralBooleanTrueType.

	node := self parseSource: 'false'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: false.
	self assert: node type isLiteralBooleanFalseType.

	node := self parseSource: 'nil'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: nil.
	self assert: node type isUndefinedType.

	node := self parseSource: '1'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.
	self assert: node type isLiteralIntegerType.

	node := self parseSource: '2.5'.	
	self assert: node isLiteralValueNode.
	self assert: node value equals: 2.5.
	self assert: node type isLiteralFloatType.

	node := self parseSource: '''Test String'''.	
	self assert: node isLiteralValueNode.
	self assert: node value equals: 'Test String'.
	self assert: node type isLiteralStringType.
		
	node := self parseSource: '#testSymbol:'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: #testSymbol:.
	self assert: node type isLiteralSymbolType.

	node := self parseSource: '#(1 2 3)'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: #(1 2 3).
	self assert: node type isLiteralArrayType.
	
	node := self parseSource: '#[1 2 3]'.
	self assert: node isLiteralValueNode.
	self assert: node value equals: #[1 2 3].
	self assert: node type isLiteralByteArrayType.

]

{ #category : #tests }
MbndPharoLanguageTest >> testMessageChainEvaluation [
	| result |
	result := (self evaluateSource: '1 + 2; negated; yourself') withoutReferences.

	self assert: result value equals: 1.
	self assert: result type isPrimitiveIntegerType.
]

{ #category : #tests }
MbndPharoLanguageTest >> testMessageChainParsing [
	| node messages |
	node := self parseSource: '1 + 2; negated; yourself'.
	self assert: node isMessageChainNode.
	self assert: node receiver isLiteralValueNode.
	self assert: node receiver value equals: 1.
	self assert: node receiver type isLiteralIntegerType.
	
	messages := node messages.
	self assert: messages size equals: 3.
	self assert: messages first selector isLiteralValueNode.
	self assert: messages first selector value equals: #+.
	self assert: messages first arguments size equals: 1.
	self assert: messages first arguments first isLiteralValueNode.
	self assert: messages first arguments first value equals: 2.
	self assert: messages first arguments first type isLiteralIntegerType.
	
	self assert: messages second selector isLiteralValueNode.
	self assert: messages second selector value equals: #negated.
	self assert: messages second arguments isEmpty.

	self assert: messages third selector isLiteralValueNode.
	self assert: messages third selector value equals: #yourself.
	self assert: messages third arguments isEmpty.

]

{ #category : #tests }
MbndPharoLanguageTest >> testReturnParsing [
	| node |
	node := self parseSource: '^ 1'.
	self assert: node isReturnStatementNode.
	self assert: node expression isLiteralValueNode.
	self assert: node expression value equals: 1.
	self assert: node expression type isLiteralIntegerType.
]

{ #category : #tests }
MbndPharoLanguageTest >> testSequenceEvaluation [
	self assert: (self evaluateSource: '1. 2. 3') unwrapMbndValue equals: 3.
]
