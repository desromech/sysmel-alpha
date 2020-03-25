Class {
	#name : #SysmelBlockClosureSignatureASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'arguments',
		'returnType',
		'orToken',
		'colonColon'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitBlockClosureSignature: self
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> arguments [
	^ arguments
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> colonColon [
	^ colonColon
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> colonColon: aSmaCCToken [
	colonColon := aSmaCCToken
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #'generated-initialize-release' }
SysmelBlockClosureSignatureASTNode >> initialize [
	super initialize.
	arguments := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> nodeVariables [
	^ #(#returnType)
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> orToken [
	^ orToken
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> orToken: aSmaCCToken [
	orToken := aSmaCCToken
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> returnType [
	^ returnType
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> returnType: aSysmelExpressionASTNode [
	self returnType notNil
		ifTrue: [ self returnType parent: nil ].
	returnType := aSysmelExpressionASTNode.
	self returnType notNil
		ifTrue: [ self returnType parent: self ]
]

{ #category : #generated }
SysmelBlockClosureSignatureASTNode >> tokenVariables [
	^ #(#colonColon #orToken)
]
