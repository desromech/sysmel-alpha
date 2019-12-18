Class {
	#name : #MbndDerivedType,
	#superclass : #MbndNativeType,
	#instVars : [
		'baseType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDerivedType class >> typeName [
	^ #_DerivedType
]

{ #category : #accessing }
MbndDerivedType >> baseType [
	<compileTime>
	^ baseType
]

{ #category : #accessing }
MbndDerivedType >> baseType: anObject [
	baseType := anObject
]

{ #category : #initialization }
MbndDerivedType >> initialize [
	super initialize.
]

{ #category : #'testing methods' }
MbndDerivedType >> isDerivedType [
	^ true
]
