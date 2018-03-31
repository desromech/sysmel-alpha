Class {
	#name : #SYMLStructureField,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'type',
		'valueType',
		'ssaValue',
		'structure'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #accessing }
SYMLStructureField >> evaluateReferenceAt: position [
	^ self
]

{ #category : #accessing }
SYMLStructureField >> evaluateTypeAt: position [
	^ type
]

{ #category : #accessing }
SYMLStructureField >> name [
	^ name
]

{ #category : #accessing }
SYMLStructureField >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLStructureField >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
SYMLStructureField >> ssaValue: anObject [
	ssaValue := anObject
]

{ #category : #accessing }
SYMLStructureField >> structure [
	^ structure
]

{ #category : #accessing }
SYMLStructureField >> structure: anObject [
	structure := anObject
]

{ #category : #accessing }
SYMLStructureField >> type [
	^ type
]

{ #category : #accessing }
SYMLStructureField >> type: anObject [
	type := anObject
]

{ #category : #accessing }
SYMLStructureField >> valueType [
	^ valueType
]

{ #category : #accessing }
SYMLStructureField >> valueType: anObject [
	valueType := anObject
]
