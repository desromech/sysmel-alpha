Class {
	#name : #MbndAstAbstractFunctionDefinitionNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndObjectWithFlags',
	#classTraits : 'TMbndObjectWithFlags classTrait',
	#instVars : [
		'prototype',
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> arguments [
	^ prototype arguments
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> body: aBody [
	body := aBody
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> concreteMethod [
	^ prototype concreteMethod
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> prototype [
	^ prototype
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> prototype: aPrototype [
	prototype := aPrototype
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> returnType [
	^ prototype returnType
]
