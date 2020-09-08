Class {
	#name : #MbndRBAstConverter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'strictPharoMode',
		'builder',
		'sourceCollection'
	],
	#category : #'SysmelLanguage-Pharo'
}

{ #category : #visiting }
MbndRBAstConverter >> compilationTarget [
	^ builder compilationTarget
]

{ #category : #'as yet unclassified' }
MbndRBAstConverter >> convertAST: ast parsedFromSourceCollection: theSourceCollection withBuilder: astBuilder [
	builder := astBuilder.
	sourceCollection := theSourceCollection.
	^ self visitNode: ast
]

{ #category : #visiting }
MbndRBAstConverter >> convertArgumentNode: argumentNode [
	^ (builder argument: argumentNode name type: nil)
		position: (self sourcePositionFromNode: argumentNode)
]

{ #category : #visiting }
MbndRBAstConverter >> convertTemporaryDefinition: temporary [
	^ (builder defineLocalVariable: temporary name asSymbol withValueType: nil withInitialValue: nil)
		position: (self sourcePositionFromNode: temporary);
		mutable;
		yourself
]

{ #category : #visiting }
MbndRBAstConverter >> sourcePositionFromNode: node [
	^ MbndSourcePosition new
		collection: sourceCollection;
		start: node start;
		start: node stop;
		yourself
]

{ #category : #accessing }
MbndRBAstConverter >> strictPharoMode [
	^ strictPharoMode
]

{ #category : #accessing }
MbndRBAstConverter >> strictPharoMode: anObject [
	strictPharoMode := anObject
]

{ #category : #visiting }
MbndRBAstConverter >> visitArrayNode: anArrayNode [
	| position array result |
	position := self sourcePositionFromNode: anArrayNode.
	array := (builder unexpandedSend: (builder literalSymbol: #basicNew:)
	to: (builder identifier: #Array) withArguments: {
			(builder literalInteger: anArrayNode children size)
				position: position
	 	})
		position: position;
		yourself.
	
	result := builder messageChainReceiver: array messages: (
		(anArrayNode children collectWithIndex: [ :each :index |
				((builder messageChainMessageSelector: ((builder literalSymbol: #at:put:)
			position: position) arguments: {
				(builder literalInteger: index)
					position: position.
				self visitNode: each
			})
					position: position)
		]) ,
		{(builder messageChainMessageSelector: ((builder literalSymbol: #yourself)
			position: position) arguments: #())
			position: position}
	).
	strictPharoMode ifTrue: [ ^ builder implicitCast: result to: self compilationTarget dynamicObjectType ].
	^ result
]

{ #category : #visiting }
MbndRBAstConverter >> visitAssignmentNode: assignmentNode [
	| receiver value position selector |
	receiver := self visitNode: assignmentNode variable.
	value := self visitNode: assignmentNode value.
	position := self sourcePositionFromNode: assignmentNode.
	selector := (builder literalSymbol: #assignValue:)
		position: position.
	^ (builder unexpandedSend: selector to: receiver withArguments: { value })
		position: position
]

{ #category : #visiting }
MbndRBAstConverter >> visitBlockNode: blockNode [
	| arguments body |
	arguments := blockNode arguments collect: [ :arg | self convertArgumentNode: arg ].
	body := self visitNode: blockNode body.
	
	^ (builder blockClosure: body arguments: arguments returnType: nil)
		position: (self sourcePositionFromNode: blockNode)
]

{ #category : #visiting }
MbndRBAstConverter >> visitCascadeNode: cascadeNode [
	| receiver messagePosition selector messages |
	receiver := self visitNode: cascadeNode messages first receiver.
	messages := cascadeNode messages collect: [ :message |
		messagePosition := self sourcePositionFromNode: message.
		selector := (builder literalSymbol: message selector)
			position: messagePosition.
		(builder messageChainMessageSelector: selector arguments: (message arguments collect: [:arg |
			self visitNode: arg
		]))
			position: messagePosition;
			shouldBeExpandedToDynamicMessage: strictPharoMode;
			yourself
	].
	^ (builder messageChainReceiver: receiver messages: messages)
		position: (self sourcePositionFromNode: cascadeNode)
]

{ #category : #visiting }
MbndRBAstConverter >> visitLiteralArrayNode: node [
	| contents type |
	contents := node value.
	type := node isForByteArray
		ifTrue: [ self compilationTarget literalByteArrayType ]
		ifFalse: [ self compilationTarget literalArrayType ].
	^ (builder literal: contents type: type)
		position: (self sourcePositionFromNode: node).
]

{ #category : #visiting }
MbndRBAstConverter >> visitLiteralNode: node [
	strictPharoMode ifTrue: [ ^ builder literal: node value type: (node value mbndLiteralTypeWithTarget: self compilationTarget) asDynamicObjectTypeForLiteral ].
	^ (node value asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
		position: (self sourcePositionFromNode: node)
]

{ #category : #visiting }
MbndRBAstConverter >> visitMessageNode: messageNode [ 
	| messagePosition selector |
	self assert: messageNode isCascaded not.

	messagePosition := self sourcePositionFromNode: messageNode.
	selector := (builder literalSymbol: messageNode selector)
		position: messagePosition.
	^ (builder unexpandedSend: selector
		to: (self visitNode: messageNode receiver)
		withArguments: (messageNode arguments collect: [ :arg | self visitNode: arg ]))
		position: messagePosition;
		shouldBeExpandedToDynamicMessage: strictPharoMode;
		yourself
]

{ #category : #visiting }
MbndRBAstConverter >> visitMethodNode: aMethodNode [
	| arguments pragmas body position prototype |
	arguments := aMethodNode arguments collect: [ :arg | self convertArgumentNode: arg ].
	pragmas := aMethodNode pragmas collect: [ :each | self visitNode: each ].
	body := self visitNode: aMethodNode body.
	self flag: 'Fixme: avoid having to add this explicit self'.
	position := self sourcePositionFromNode: aMethodNode.
	body := (builder sequence: {
		body.
		builder identifier: #self
	})
		position: position;
		pragmas: pragmas asArray.

	prototype := (builder messagePrototypeSelector: aMethodNode selector arguments: arguments returnType: nil)
		position: position;
		yourself.
	^ (builder messagePrototype: prototype definitionBody: body)
		position: position;
		yourself
]

{ #category : #visiting }
MbndRBAstConverter >> visitPragmaNode: aPragmaNode [
	^ (builder pragmaSelector: aPragmaNode selector
		arguments: (aPragmaNode arguments collect: [ :each | self visitNode: each ]))
		position: (self sourcePositionFromNode: aPragmaNode)
]

{ #category : #visiting }
MbndRBAstConverter >> visitReturnNode: returnNode [
	^ (builder return: (self visitNode: returnNode value))
		position: (self sourcePositionFromNode: returnNode)
]

{ #category : #visiting }
MbndRBAstConverter >> visitSequenceNode: sequenceNode [
	| result |
	result := (builder sequence:
		(sequenceNode temporaries collect: [:temporary | self convertTemporaryDefinition: temporary ]) ,
		(sequenceNode statements collect: [:statement | self visitNode: statement]))
		position: (self sourcePositionFromNode: sequenceNode).
	^ result lexicallyScoped
	
]

{ #category : #visiting }
MbndRBAstConverter >> visitVariableNode: node [
	^ (builder identifier: node name)
		position: (self sourcePositionFromNode: node);
		shouldBeAccessedAsDynamicObject: strictPharoMode;
		yourself
]
