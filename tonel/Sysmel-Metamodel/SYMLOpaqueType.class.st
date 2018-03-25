Class {
	#name : #SYMLOpaqueType,
	#superclass : #SYMLType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #printing }
SYMLOpaqueType >> printOn: aStream [
	aStream nextPutAll: self name
]
