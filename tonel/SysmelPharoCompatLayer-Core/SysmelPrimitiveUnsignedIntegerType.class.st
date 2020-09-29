Class {
	#name : #SysmelPrimitiveUnsignedIntegerType,
	#superclass : #SysmelPrimitiveIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveUnsignedIntegerType class >> isPrimitiveUnsignedIntegerType [
	^ true
]

{ #category : #testing }
SysmelPrimitiveUnsignedIntegerType class >> isSigned [
	^ false
]

{ #category : #testing }
SysmelPrimitiveUnsignedIntegerType class >> isUnsigned [
	^ true
]
