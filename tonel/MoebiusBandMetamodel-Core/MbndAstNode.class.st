"
I represent a generic AST node in the MoebiusBand meta model. I am used to implement language agnostic macro expansion.
"
Class {
	#name : #MbndAstNode,
	#superclass : #Object,
	#instVars : [
		'position',
		'type'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstNode >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #initialization }
MbndAstNode >> initialize [
	super initialize.
	position := MbndSourcePosition empty.
]

{ #category : #testing }
MbndAstNode >> isBreakStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCasesOfCaseNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCasesOfDefaultCaseNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isCasesOfNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isContinueStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isDoWhileLoopNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isExpandedMessageSendNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isFunctionCallNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIdentifierReferenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isIfConditionNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLexicalScopeNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLiteralSymbolValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isLiteralValueNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMessageChainMessageNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isMessageChainNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isPragmaNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isQuasiQuoteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isQuasiUnquoteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isQuoteNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSequenceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isSpliceNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isStatementNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isUnexpandedMessageSendNode [
	^ false
]

{ #category : #testing }
MbndAstNode >> isWhileLoopNode [
	^ false
]

{ #category : #'as yet unclassified' }
MbndAstNode >> lexicallyScoped [
	^ MbndAstLexicalScopeNode new
		position: position;
		expression: self;
		yourself
]

{ #category : #accessing }
MbndAstNode >> position [
	^ position
]

{ #category : #accessing }
MbndAstNode >> position: anObject [
	position := anObject
]

{ #category : #printing }
MbndAstNode >> printValueString [
	^ self printString
]

{ #category : #accessing }
MbndAstNode >> type [
	^ type
]

{ #category : #accessing }
MbndAstNode >> type: anObject [
	type := anObject
]
