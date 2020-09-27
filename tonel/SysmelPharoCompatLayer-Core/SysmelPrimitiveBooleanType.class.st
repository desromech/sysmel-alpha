Class {
	#name : #SysmelPrimitiveBooleanType,
	#superclass : #SysmelPrimitiveNumberType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveBooleanType class >> isAbstract [
	^ self == SysmelPrimitiveBooleanType
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveBooleanType class >> validateImplicitCastOfValue: aValue [
	self assert: (aValue == false or: [aValue == true]).
	^ aValue
]
