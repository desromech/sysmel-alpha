Class {
	#name : #SYMLValueReturnException,
	#superclass : #Exception,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLValueReturnException >> value [
	^ value
]

{ #category : #accessing }
SYMLValueReturnException >> value: anObject [
	value := anObject
]
