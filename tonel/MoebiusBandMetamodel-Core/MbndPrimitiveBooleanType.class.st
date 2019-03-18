Class {
	#name : #MbndPrimitiveBooleanType,
	#superclass : #MbndPrimitiveType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveBooleanType class >> typeName [
	^ #_PrimitiveBooleanType
]

{ #category : #initialization }
MbndPrimitiveBooleanType >> initialize [
	super initialize.
	self
		instanceSize: 1;
		instanceAlignment: 1
]

{ #category : #'testing methods' }
MbndPrimitiveBooleanType >> isPrimitiveBooleanType [
	^ true
]
