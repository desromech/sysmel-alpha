Class {
	#name : #SYMLLiteralObjectProxy,
	#superclass : #SYMLReflectionProxy,
	#instVars : [
		'type'
	],
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #accessing }
SYMLLiteralObjectProxy >> type [
	^ type
]

{ #category : #accessing }
SYMLLiteralObjectProxy >> type: anObject [
	type := anObject
]
