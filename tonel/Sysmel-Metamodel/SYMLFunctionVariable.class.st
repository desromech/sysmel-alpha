Class {
	#name : #SYMLFunctionVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'ssaValue'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'code generation' }
SYMLFunctionVariable >> generateSSAReferenceWith: builder [
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionVariable >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionVariable >> ssaValue: anObject [
	ssaValue := anObject
]
