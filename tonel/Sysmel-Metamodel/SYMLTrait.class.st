Class {
	#name : #SYMLTrait,
	#superclass : #SYMLAbstractType,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #printing }
SYMLTrait >> printOn: aStream [
	aStream nextPutAll: 'trait '; nextPutAll: self validName
]
