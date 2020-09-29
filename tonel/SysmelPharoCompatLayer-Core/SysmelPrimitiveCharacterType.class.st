Class {
	#name : #SysmelPrimitiveCharacterType,
	#superclass : #SysmelPrimitiveUnsignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveCharacterType class >> isAbstract [
	^ self == SysmelPrimitiveCharacterType
]

{ #category : #testing }
SysmelPrimitiveCharacterType class >> isPrimitiveCharacterType [
	^ true
]
