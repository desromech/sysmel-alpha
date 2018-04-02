Class {
	#name : #SYMLSimpleType,
	#superclass : #SYMLAbstractType,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #definition }
SYMLSimpleType >> definitionScopeClass [
	^ SYMLTypeScope
]

{ #category : #printing }
SYMLSimpleType >> printOn: aStream [
	aStream nextPutAll: 'type '; nextPutAll: self validName
]
