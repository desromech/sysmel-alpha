Class {
	#name : #SysmelDecoratedType,
	#superclass : #SysmelDerivedType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelDecoratedType class >> isAbstract [
	^ self == SysmelDecoratedType
]

{ #category : #testing }
SysmelDecoratedType class >> isDecoratedType [
	^ true
]
