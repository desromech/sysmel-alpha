Class {
	#name : #SysmelPrimitiveIntegerType,
	#superclass : #SysmelPrimitiveNumberType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveIntegerType class >> isAbstract [
	^ self == SysmelPrimitiveIntegerType
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveIntegerType class >> validateImplicitCastOfValue: aValue [
	self assert: aValue isInteger.
	^ aValue
]
