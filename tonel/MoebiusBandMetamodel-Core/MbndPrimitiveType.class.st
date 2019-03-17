"
I represent a primitive type. My instances are usually able to fit in single CPU registers, or they have dedicated CPU instructions for operating with them. They correspond to primitive C types.
"
Class {
	#name : #MbndPrimitiveType,
	#superclass : #MbndNativeType,
	#instVars : [
		'name',
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPrimitiveType >> instanceAlignment [
	^ instanceAlignment
]

{ #category : #accessing }
MbndPrimitiveType >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
MbndPrimitiveType >> instanceSize [
	^ instanceSize
]

{ #category : #accessing }
MbndPrimitiveType >> instanceSize: anObject [
	instanceSize := anObject
]

{ #category : #'testing methods' }
MbndPrimitiveType >> isPrimitiveType [
	^ true
]

{ #category : #accessing }
MbndPrimitiveType >> name [
	^ name
]

{ #category : #accessing }
MbndPrimitiveType >> name: anObject [
	name := anObject
]
