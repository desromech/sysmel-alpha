Class {
	#name : #MbndLiteralStringType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralStringType class >> typeName [
	^ #_LiteralString
]

{ #category : #adding }
MbndLiteralStringType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self addConversionTo: self compilationTarget uint8Type const pointer rule: MbndLiteralValueTypeChangeConversionRule .
]

{ #category : #'testing methods' }
MbndLiteralStringType >> isLiteralStringType [
	^ true
]
