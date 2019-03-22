Class {
	#name : #MbndLiteralNumberType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
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
	).
]

{ #category : #testing }
MbndLiteralNumberType >> isLiteralNumberType [
	^ true
]
