Class {
	#name : #SYMLPrimitiveType,
	#superclass : #SYMLType,
	#instVars : [
		'name',
		'size',
		'alignment'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #accessing }
SYMLPrimitiveType >> alignment [
	^ alignment
]

{ #category : #accessing }
SYMLPrimitiveType >> alignment: anObject [
	alignment := anObject
]

{ #category : #testing }
SYMLPrimitiveType >> isScalarType [
	^ true
]

{ #category : #accessing }
SYMLPrimitiveType >> name [
	^ name
]

{ #category : #accessing }
SYMLPrimitiveType >> name: anObject [
	name := anObject
]

{ #category : #printing }
SYMLPrimitiveType >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #accessing }
SYMLPrimitiveType >> size [
	^ size
]

{ #category : #accessing }
SYMLPrimitiveType >> size: anObject [
	size := anObject
]

{ #category : #accessing }
SYMLPrimitiveType >> ssaType: anSSAType [
	ssaType := anSSAType
]
