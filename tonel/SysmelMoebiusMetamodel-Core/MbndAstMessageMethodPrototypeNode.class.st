Class {
	#name : #MbndAstMessageMethodPrototypeNode,
	#superclass : #MbndAstAbstractFunctionPrototypeNode,
	#instVars : [
		'selector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageMethodPrototypeNode >> accept: aVisitor [
	^ aVisitor visitMessagePrototypeNode: self
]

{ #category : #visiting }
MbndAstMessageMethodPrototypeNode >> isMessageMethodPrototypeNode [
	^ true
]

{ #category : #running }
MbndAstMessageMethodPrototypeNode >> override [
	<compileTime>
	self addFlag: #override
]

{ #category : #accessing }
MbndAstMessageMethodPrototypeNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMessageMethodPrototypeNode >> selector: anObject [
	selector := anObject
]

{ #category : #'as yet unclassified' }
MbndAstMessageMethodPrototypeNode >> virtual [
	<compileTime>
	self addFlag: #virtual
]
