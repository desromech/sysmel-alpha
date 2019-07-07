Class {
	#name : #MbndGeneratedSymbol,
	#superclass : #Object,
	#instVars : [
		'name',
		'context'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #printing }
MbndGeneratedSymbol >> = other [
	^ self class == other class and: [ name == other name and: [ context == other context ] ]
]

{ #category : #printing }
MbndGeneratedSymbol >> asPrettySymbolName [
	^ name
]

{ #category : #accessing }
MbndGeneratedSymbol >> context [
	^ context
]

{ #category : #accessing }
MbndGeneratedSymbol >> context: anObject [
	context := anObject
]

{ #category : #printing }
MbndGeneratedSymbol >> hash [
	^ (self class identityHash bitXor: name identityHash) bitXor: context identityHash
]

{ #category : #testing }
MbndGeneratedSymbol >> isMbndGeneratedSymbol [
	^ true
]

{ #category : #accessing }
MbndGeneratedSymbol >> isSymbol [
	^ true
]

{ #category : #accessing }
MbndGeneratedSymbol >> name [
	^ name
]

{ #category : #accessing }
MbndGeneratedSymbol >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndGeneratedSymbol >> numArgs [
	^ name numArgs
]

{ #category : #printing }
MbndGeneratedSymbol >> printOn: aStream [
	aStream nextPutAll: '(gensym ';  print: name; space; print: context; nextPut: $) 
]
