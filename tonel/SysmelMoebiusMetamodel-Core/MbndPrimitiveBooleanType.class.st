Class {
	#name : #MbndPrimitiveBooleanType,
	#superclass : #MbndPrimitiveType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveBooleanType class >> typeName [
	^ #_PrimitiveBooleanType
]

{ #category : #visiting }
MbndPrimitiveBooleanType >> accept: aVisitor [
	^ aVisitor visitPrimitiveBooleanType: self
]

{ #category : #converting }
MbndPrimitiveBooleanType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget booleanType
]

{ #category : #'default values' }
MbndPrimitiveBooleanType >> defaultValue [
	^ MbndValue value: false type: self
]

{ #category : #initialization }
MbndPrimitiveBooleanType >> initialize [
	super initialize.
	self
		instanceSize: 1;
		instanceAlignment: 1
]

{ #category : #testing }
MbndPrimitiveBooleanType >> isAcceptableLiteralValue: literalValue [
	^ literalValue == true or: [ literalValue == false ]
]

{ #category : #'testing methods' }
MbndPrimitiveBooleanType >> isPrimitiveBooleanType [
	^ true
]
