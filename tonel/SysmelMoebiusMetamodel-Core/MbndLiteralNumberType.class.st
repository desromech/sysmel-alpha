Class {
	#name : #MbndLiteralNumberType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralNumberType class >> typeName [
	^ #_LiteralNumberType
]

{ #category : #initialization }
MbndLiteralNumberType >> initialize [
	super initialize.
	self addLiteralHostDelegationMacrosFor: #(
		+ - * / %
		negated sqrt
		
		< <= >= >
		= ~= == ~~
	).
]

{ #category : #testing }
MbndLiteralNumberType >> isLiteralNumberType [
	^ true
]
