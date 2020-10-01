Class {
	#name : #SysmelPrimitiveBooleanType,
	#superclass : #SysmelPrimitiveNumberType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveBooleanType class >> isAbstract [
	^ self == SysmelPrimitiveBooleanType
]

{ #category : #testing }
SysmelPrimitiveBooleanType class >> isPrimitiveBooleanType [
	^ true
]

{ #category : #'instance creation' }
SysmelPrimitiveBooleanType class >> new [
	^ false
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveBooleanType class >> validateImplicitCastOfValue: aValue [
	self assert: (aValue == false or: [aValue == true]).
	^ aValue
]
