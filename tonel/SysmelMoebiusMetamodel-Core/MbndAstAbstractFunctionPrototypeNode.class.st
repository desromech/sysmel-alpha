Class {
	#name : #MbndAstAbstractFunctionPrototypeNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndObjectWithFlags',
	#classTraits : 'TMbndObjectWithFlags classTrait',
	#instVars : [
		'arguments',
		'returnType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #initialization }
MbndAstAbstractFunctionPrototypeNode >> initialize [
	super initialize.
	arguments := #().
	flags := #().
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> returnType: aTypeExpression [
	returnType := aTypeExpression
]
