Class {
	#name : #MbndPrimitiveCharacterCodeType,
	#superclass : #MbndPrimitiveIntegerType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveCharacterCodeType class >> typeName [
	^ #_PrimitiveCharacterCodeType
]

{ #category : #visiting }
MbndPrimitiveCharacterCodeType >> accept: aVisitor [
	^ aVisitor visitPrimitiveCharacterCodeType: self
]

{ #category : #converting }
MbndPrimitiveCharacterCodeType >> asIntegerType [
	instanceSize = 1 ifTrue: [ ^ self compilationTarget uint8Type ].
	instanceSize = 2 ifTrue: [ ^ self compilationTarget uint16Type ].
	instanceSize = 4 ifTrue: [ ^ self compilationTarget uint32Type ].
	self error: 'Invalid character code type.'
]

{ #category : #converting }
MbndPrimitiveCharacterCodeType >> asSignedType [
	^ self asIntegerType asSignedType
]

{ #category : #converting }
MbndPrimitiveCharacterCodeType >> asUnsignedType [
	^ self asIntegerType asUnsignedType
]

{ #category : #'default values' }
MbndPrimitiveCharacterCodeType >> defaultValueAt: aPosition [
	^ MbndValue value: Character null type: self
]

{ #category : #'testing methods' }
MbndPrimitiveCharacterCodeType >> isPrimitiveCharacterCodeType [
	^ true
]
