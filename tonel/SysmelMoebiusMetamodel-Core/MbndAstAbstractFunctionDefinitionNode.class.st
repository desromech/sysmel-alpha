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
MbndAstAbstractFunctionDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> body: aBody [
	body := aBody
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> prototype [
	^ prototype
]

{ #category : #accessing }
MbndAstAbstractFunctionDefinitionNode >> prototype: aPrototype [
	prototype := aPrototype
]
