Class {
	#name : #MbndBlockClosureType,
	#superclass : #MbndFunctionalType,
	#instVars : [
		'functionType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndBlockClosureType class >> typeName [
	^ #_BlockClosureType
]

{ #category : #visiting }
MbndBlockClosureType >> accept: aVisitor [
	^ aVisitor visitBlockClosureType: self
]

{ #category : #accessing }
MbndBlockClosureType >> argumentTypes [
	<compileTime>
	^ functionType argumentTypes
]

{ #category : #accessing }
MbndBlockClosureType >> functionType [
	<compileTime>
	^ functionType
]

{ #category : #accessing }
MbndBlockClosureType >> functionType: anObject [
	functionType := anObject
]

{ #category : #'testing methods' }
MbndBlockClosureType >> isBlockClosureType [
	^ true
]

{ #category : #accessing }
MbndBlockClosureType >> returnType [
	<compileTime>
	^ functionType returnType
]
