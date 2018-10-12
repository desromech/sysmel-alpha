Class {
	#name : #SYMLBlockClosureWrapper,
	#superclass : #SYMLCompileTimeFunction,
	#instVars : [
		'blockClosure'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLBlockClosureWrapper >> blockClosure [
	^ blockClosure
]

{ #category : #accessing }
SYMLBlockClosureWrapper >> blockClosure: anObject [
	blockClosure := anObject
]

{ #category : #evaluating }
SYMLBlockClosureWrapper >> cull: a1 cull: a2 [
	^ blockClosure cull: a1 cull: a2
]

{ #category : #evaluating }
SYMLBlockClosureWrapper >> cull: a1 cull: a2 cull: a3 [
	^ blockClosure cull: a1 cull: a2 cull: a3
]

{ #category : #evaluating }
SYMLBlockClosureWrapper >> cull: a1 cull: a2 cull: a3 cull: a4 [
	^ blockClosure cull: a1 cull: a2 cull: a3 cull: a4
]

{ #category : #'as yet unclassified' }
SYMLBlockClosureWrapper >> cull: a1 cull: a2 cull: a3 cull: a4 cull: a5 [
	blockClosure numArgs < 5 ifTrue: [
		^ self cull: a1 cull: a2 cull: a3 cull: a4
	].
	^ blockClosure valueWithArguments: { a1 . a2 . a3 . a4 . a5 }
]

{ #category : #evaluating }
SYMLBlockClosureWrapper >> numArgs [
	^ blockClosure numArgs
]

{ #category : #evaluating }
SYMLBlockClosureWrapper >> valueWithReceiver: aReceiver arguments: theArguments [
	^ blockClosure valueWithArguments: theArguments
]
