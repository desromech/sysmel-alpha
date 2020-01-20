Class {
	#name : #MbndAstAbstractFunctionDefinitionNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
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

{ #category : #converting }
MbndAstAbstractFunctionDefinitionNode >> asBlockClosureNode [
	^ MbndAstBlockClosureNode new
		position: self;
		isBlockWithNonLocalReturn: false;
		arguments: prototype arguments;
		returnType: prototype returnType;
		body: body;
		yourself
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
