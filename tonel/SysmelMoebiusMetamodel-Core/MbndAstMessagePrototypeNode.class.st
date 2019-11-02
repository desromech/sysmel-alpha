Class {
	#name : #MbndAstMessagePrototypeNode,
	#superclass : #MbndAstAbstractFunctionPrototypeNode,
	#instVars : [
		'selector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessagePrototypeNode >> accept: aVisitor [
	^ aVisitor visitMessagePrototypeNode: self
]

{ #category : #visiting }
MbndAstMessagePrototypeNode >> isMessagePrototypeNode [
	^ true
]

{ #category : #running }
MbndAstMessagePrototypeNode >> override [
	<compileTime>
	self addFlag: #override
]

{ #category : #accessing }
MbndAstMessagePrototypeNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMessagePrototypeNode >> selector: anObject [
	selector := anObject
]

{ #category : #'as yet unclassified' }
MbndAstMessagePrototypeNode >> virtual [
	<compileTime>
	self addFlag: #virtual
]
