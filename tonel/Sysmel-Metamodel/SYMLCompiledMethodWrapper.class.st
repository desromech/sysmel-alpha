Class {
	#name : #SYMLCompiledMethodWrapper,
	#superclass : #SYMLCompileTimeFunction,
	#instVars : [
		'method'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #evaluating }
SYMLCompiledMethodWrapper >> cull: a1 [
	method numArgs < 1 ifTrue: [
		^ self value
	].
	^ method valueWithReceiver: nil arguments:  { a1 }
]

{ #category : #evaluating }
SYMLCompiledMethodWrapper >> cull: a1 cull: a2 [
	method numArgs < 2 ifTrue: [
		^ self cull: a1
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 }
]

{ #category : #evaluating }
SYMLCompiledMethodWrapper >> cull: a1 cull: a2 cull: a3 [
	method numArgs < 3 ifTrue: [
		^ self cull: a1 cull: a2
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 . a3 }
]

{ #category : #evaluating }
SYMLCompiledMethodWrapper >> cull: a1 cull: a2 cull: a3 cull: a4 [
	method numArgs < 4 ifTrue: [
		^ self cull: a1 cull: a2 cull: a3
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 . a3 . a4 }
]

{ #category : #'as yet unclassified' }
SYMLCompiledMethodWrapper >> cull: a1 cull: a2 cull: a3 cull: a4 cull: a5 [
	method numArgs < 5 ifTrue: [
		^ self cull: a1 cull: a2 cull: a3 cull: a4
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 . a3 . a4 . a5 }
]

{ #category : #accessing }
SYMLCompiledMethodWrapper >> method [
	^ method
]

{ #category : #accessing }
SYMLCompiledMethodWrapper >> method: anObject [
	method := anObject
]

{ #category : #evaluating }
SYMLCompiledMethodWrapper >> value [
	^ method valueWithReceiver: nil arguments: #()
]

{ #category : #evaluating }
SYMLCompiledMethodWrapper >> valueWithReceiver: aReceiver arguments: theArguments [
	^ method valueWithReceiver: aReceiver arguments: theArguments
]
