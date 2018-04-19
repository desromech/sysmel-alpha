Class {
	#name : #SYMLClass,
	#superclass : #SYMLStructure,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #printing }
SYMLClass >> printOn: aStream [
	aStream nextPutAll: 'class '; nextPutAll: self printingName
]

{ #category : #'as yet unclassified' }
SYMLClass >> typeKindBaseTrait [
	^ self compilationTarget classTypeTrait
]
