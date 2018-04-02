Class {
	#name : #SYMLStructure,
	#superclass : #SYMLAbstractType,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #definition }
SYMLStructure >> definitionScopeClass [
	^ SYMLStructureScope
]

{ #category : #printing }
SYMLStructure >> printOn: aStream [
	aStream nextPutAll: 'structure '; nextPutAll: self validName
]
