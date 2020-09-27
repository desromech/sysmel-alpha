Class {
	#name : #SysmelPrimitiveFloatType,
	#superclass : #SysmelPrimitiveNumberType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveFloatType class >> isAbstract [
	^ self == SysmelPrimitiveFloatType
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveFloatType class >> validateImplicitCastOfValue: aValue [
	self assert: aValue isNumber.
	^ aValue asFloat
]
