Class {
	#name : #SysmelPrimitiveIntegerType,
	#superclass : #SysmelPrimitiveNumberType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveIntegerType class >> isAbstract [
	^ self == SysmelPrimitiveIntegerType
]

{ #category : #testing }
SysmelPrimitiveIntegerType class >> isPrimitiveIntegerType [
	^ true
]

{ #category : #testing }
SysmelPrimitiveIntegerType class >> isSigned [
	^ self subclassResponsibility
]

{ #category : #testing }
SysmelPrimitiveIntegerType class >> isUnsigned [
	^ self subclassResponsibility
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveIntegerType class >> one [
	^ 1
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveIntegerType class >> ones [
	^ 1
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveIntegerType class >> validateImplicitCastOfValue: aValue [
	self assert: aValue isInteger.
	^ aValue
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveIntegerType class >> zero [
	^ 0
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveIntegerType class >> zeros [
	^ 0
]
