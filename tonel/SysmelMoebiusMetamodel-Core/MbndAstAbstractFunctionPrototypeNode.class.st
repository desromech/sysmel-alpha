Class {
	#name : #MbndAstAbstractFunctionPrototypeNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
	#instVars : [
		'arguments',
		'returnType',
		'functionType',
		'concreteMethod',
		'ownerProgramEntity',
		'specialSemantics'
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

{ #category : #testing }
MbndAstAbstractFunctionPrototypeNode >> isCVariadic [
	^ false
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> returnType: aTypeExpression [
	returnType := aTypeExpression
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> specialSemantics [
	^ specialSemantics
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> specialSemantics: anObject [
	specialSemantics := anObject
]
