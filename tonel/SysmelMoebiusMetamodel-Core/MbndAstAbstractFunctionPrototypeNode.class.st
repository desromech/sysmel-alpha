Class {
	#name : #MbndAstAbstractFunctionPrototypeNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndObjectWithFlags',
	#classTraits : 'TMbndObjectWithFlags classTrait',
	#instVars : [
		'arguments',
		'returnType',
		'functionType',
		'concreteMethod'
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

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> concreteMethod [
	^ concreteMethod
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> concreteMethod: anObject [
	concreteMethod := anObject
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> functionType [
	^ functionType
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> functionType: anObject [
	functionType := anObject
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
