Class {
	#name : #SYMLTrait,
	#superclass : #SYMLAbstractType,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #printing }
SYMLTrait >> printOn: aStream [
	aStream nextPutAll: 'trait '; nextPutAll: self validName
]
