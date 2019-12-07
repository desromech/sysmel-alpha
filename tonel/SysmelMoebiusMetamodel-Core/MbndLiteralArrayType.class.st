Class {
	#name : #MbndLiteralArrayType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralArrayType class >> typeName [
	^ #_LiteralArray
]

{ #category : #adding }
MbndLiteralArrayType >> addDefaultConversionRules [
	self
		addConversionRule: MbndLiteralArrayToArrayConversionRule new.

]

{ #category : #'testing methods' }
MbndLiteralArrayType >> isLiteralArrayType [
	^ true
]
