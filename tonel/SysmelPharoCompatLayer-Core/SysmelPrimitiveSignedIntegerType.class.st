Class {
	#name : #SysmelPrimitiveSignedIntegerType,
	#superclass : #SysmelPrimitiveIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveSignedIntegerType class >> isSigned [
	^ true
]

{ #category : #testing }
SysmelPrimitiveSignedIntegerType class >> isUnsigned [
	^ false
]
