Class {
	#name : #SYMLBlockClosure,
	#superclass : #SYMLProgramEntityWithLocation,
	#instVars : [
		'arguments',
		'returnType',
		'type',
		'body'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #accessing }
SYMLBlockClosure >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLBlockClosure >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLBlockClosure >> body [
	^ body
]

{ #category : #accessing }
SYMLBlockClosure >> body: anObject [
	body := anObject
]

{ #category : #accessing }
SYMLBlockClosure >> returnType [
	^ returnType
]

{ #category : #accessing }
SYMLBlockClosure >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
SYMLBlockClosure >> type [
	^ type ifNil: [ type := self compilationTarget closureArguments: (arguments collect: #type) returnType: returnType ]
]
