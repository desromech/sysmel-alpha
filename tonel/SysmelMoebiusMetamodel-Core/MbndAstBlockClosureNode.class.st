Class {
	#name : #MbndAstBlockClosureNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'arguments',
		'returnType',
		'body',
		'blockClosureProgramEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBlockClosureNode >> accept: aVisitor [
	^ aVisitor visitBlockClosureNode: self
]

{ #category : #accessing }
MbndAstBlockClosureNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstBlockClosureNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
MbndAstBlockClosureNode >> asFunctionDefinitionNode [
	| prototype |
	prototype := MbndAstFunctionPrototypeNode new
		position: self;
		arguments: arguments;
		returnType: returnType;
		yourself.
	^ MbndAstFunctionDefinitionNode new
		position: self;
		prototype: prototype;
		body: body;
		yourself
]

{ #category : #accessing }
MbndAstBlockClosureNode >> blockClosureProgramEntity [
	^ blockClosureProgramEntity
]

{ #category : #accessing }
MbndAstBlockClosureNode >> blockClosureProgramEntity: anObject [
	blockClosureProgramEntity := anObject
]

{ #category : #accessing }
MbndAstBlockClosureNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstBlockClosureNode >> body: anObject [
	body := anObject
]

{ #category : #'as yet unclassified' }
MbndAstBlockClosureNode >> isBlockClosureNode [
	^ true
]

{ #category : #accessing }
MbndAstBlockClosureNode >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndAstBlockClosureNode >> returnType: anObject [
	returnType := anObject
]
