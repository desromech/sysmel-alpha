Class {
	#name : #SysmelBlockExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expressions',
		'pragmas',
		'blockClosureSignature',
		'lbracket',
		'rbracket'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelBlockExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitBlockExpression: self
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> blockClosureSignature [
	^ blockClosureSignature
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> blockClosureSignature: aSysmelBlockClosureSignatureASTNode [
	self blockClosureSignature notNil
		ifTrue: [ self blockClosureSignature parent: nil ].
	blockClosureSignature := aSysmelBlockClosureSignatureASTNode.
	self blockClosureSignature notNil
		ifTrue: [ self blockClosureSignature parent: self ]
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> compositeNodeVariables [
	^ #(#pragmas)
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> expressions [
	^ expressions
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> expressions: aSysmelExpressionListASTNode [
	self expressions notNil
		ifTrue: [ self expressions parent: nil ].
	expressions := aSysmelExpressionListASTNode.
	self expressions notNil
		ifTrue: [ self expressions parent: self ]
]

{ #category : #'generated-initialize-release' }
SysmelBlockExpressionASTNode >> initialize [
	super initialize.
	pragmas := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> lbracket [
	^ lbracket
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> lbracket: aSmaCCToken [
	lbracket := aSmaCCToken
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> nodeVariables [
	^ #(#blockClosureSignature #expressions)
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> pragmas [
	^ pragmas
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> pragmas: anOrderedCollection [
	self setParents: self pragmas to: nil.
	pragmas := anOrderedCollection.
	self setParents: self pragmas to: self
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> rbracket [
	^ rbracket
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> rbracket: aSmaCCToken [
	rbracket := aSmaCCToken
]

{ #category : #generated }
SysmelBlockExpressionASTNode >> tokenVariables [
	^ #(#lbracket #rbracket)
]
