Class {
	#name : #SYMLLiteralObjectProxy,
	#superclass : #SYMLReflectionProxy,
	#instVars : [
		'literal',
		'type'
	],
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #accessing }
SYMLLiteralObjectProxy >> literal [
	^ literal
]

{ #category : #accessing }
SYMLLiteralObjectProxy >> literal: anObject [
	literal := anObject
]

{ #category : #accessing }
SYMLLiteralObjectProxy >> type [
	^ type
]

{ #category : #accessing }
SYMLLiteralObjectProxy >> type: anObject [
	type := anObject
]
