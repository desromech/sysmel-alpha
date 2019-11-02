Class {
	#name : #MbndAstFunctionPrototypeNode,
	#superclass : #MbndAstAbstractFunctionPrototypeNode,
	#instVars : [
		'name'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #flags }
MbndAstFunctionPrototypeNode >> CVariadic [
	self addFlag: #cvariadic
]

{ #category : #visiting }
MbndAstFunctionPrototypeNode >> accept: aVisitor [
	^ aVisitor visitFunctionPrototypeNode: self
]

{ #category : #flags }
MbndAstFunctionPrototypeNode >> externC [
	^ self addFlag: #externC
]

{ #category : #flags }
MbndAstFunctionPrototypeNode >> isCVariadic [
	^ self hasFlag: #cvariadic
]

{ #category : #flags }
MbndAstFunctionPrototypeNode >> isExternC [
	^ self hasFlag: #externC
]

{ #category : #visiting }
MbndAstFunctionPrototypeNode >> isFunctionPrototypeNode [
	^ true
]

{ #category : #accessing }
MbndAstFunctionPrototypeNode >> name [
	^ name
]

{ #category : #accessing }
MbndAstFunctionPrototypeNode >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
MbndAstFunctionPrototypeNode >> override [
	<compileTime>
	self addFlag: #override
]

{ #category : #'as yet unclassified' }
MbndAstFunctionPrototypeNode >> virtual [
	<compileTime>
	self addFlag: #virtual
]
