"
I represent a primitive type. My instances are usually able to fit in single CPU registers, or they have dedicated CPU instructions for operating with them. They correspond to primitive C types.
"
Class {
	#name : #MbndPrimitiveType,
	#superclass : #MbndNativeType,
	#instVars : [
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveType class >> typeName [
	^ #_PrimitiveType
]

{ #category : #accessing }
MbndPrimitiveType >> instanceAlignment [
	<compileTime>
	^ instanceAlignment
]

{ #category : #accessing }
MbndPrimitiveType >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
MbndPrimitiveType >> instanceSize [
	<compileTime>
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
