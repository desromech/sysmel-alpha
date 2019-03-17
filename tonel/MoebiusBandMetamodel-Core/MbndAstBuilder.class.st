Class {
	#name : #MbndAstBuilder,
	#superclass : #Object,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #'builder methods' }
MbndAstBuilder >> identifier: symbol [
	^ MbndAstIdentifierReferenceNode new symbol: symbol
]

{ #category : #'builder methods' }
MbndAstBuilder >> literal: literalValue typeName: typeSelector [
	^ MbndAstLiteralValueNode new
		value: literalValue;
		type: (self typeWithName: typeSelector);
		yourself
]

{ #category : #'builder methods' }
MbndAstBuilder >> literalInteger: literalValue [
	^ self literal: literalValue typeName: #_LiteralInteger
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
MbndAstBuilder >> typeWithName: typeSelector [
	self flag: 'TODO: Fetch the type with the specific selector.'.
	^ nil
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
