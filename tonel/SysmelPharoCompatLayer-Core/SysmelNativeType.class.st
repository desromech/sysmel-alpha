Class {
	#name : #SysmelNativeType,
	#superclass : #Object,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
SysmelNativeType class >> alignedInstanceSize [
	^ self instanceSize alignedTo: self instanceAlignment
]

{ #category : #sizes }
SysmelNativeType class >> instanceAlignment [
	self subclassResponsibility
]

{ #category : #sizes }
SysmelNativeType class >> instanceSize [
	self subclassResponsibility
]

{ #category : #testing }
SysmelNativeType class >> isAbstract [
	^ self == SysmelNativeType
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveBooleanType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveCharacterType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveFloatType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveIntegerType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveMatrixType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveSignedIntegerType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveUnsignedIntegerType [
	^ false
]

{ #category : #testing }
SysmelNativeType class >> isPrimitiveVectorType [
	^ false
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> validateExplicitCastOfValue: aValue [
	^ self validateImplicitCastOfValue: aValue
]

{ #category : #'as yet unclassified' }
SysmelNativeType class >> validateImplicitCastOfValue: aValue [
	self assert: aValue class == self.
	^ aValue
]
