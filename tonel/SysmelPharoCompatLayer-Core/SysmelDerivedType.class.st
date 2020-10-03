Class {
	#name : #SysmelDerivedType,
	#superclass : #SysmelNativeType,
	#classInstVars : [
		'baseType'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelDerivedType class >> baseType [
	^ baseType
]

{ #category : #testing }
SysmelDerivedType class >> isAbstract [
	^ self == SysmelDerivedType
]

{ #category : #testing }
SysmelDerivedType class >> isDerivedType [
	^ true
]
