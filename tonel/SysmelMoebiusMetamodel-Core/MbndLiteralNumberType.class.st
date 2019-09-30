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
MbndLiteralNumberType >> addInstanceMacros [
	self class == MbndLiteralNumberType ifFalse: [ ^ self ].
	self addLiteralHostDelegationMacrosFor: #(
		+ - * / %
		negated sqrt
		
		ceiling floor
		
		< <= >= >
		= ~= == ~~
	).
	self addLiteralHostDelegationMacroFor: #'prefix--' to: #negated
]

{ #category : #testing }
MbndLiteralNumberType >> isLiteralNumberType [
	^ true
]
