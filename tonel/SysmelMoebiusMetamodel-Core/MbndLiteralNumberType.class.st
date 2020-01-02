Class {
	#name : #MbndLiteralNumberType,
	#superclass : #MbndLiteralScalarType,
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
	self addLiteralHostDelegationMacroFor: #'prefix--' to: #negated.
	self
		onMacroSelector: #u do: [ :node :builder |
			builder explicitCast: node receiver to: self compilationTarget uint32Type
		];
		onMacroSelector: #f do: [ :node :builder |
			builder explicitCast: node receiver to: self compilationTarget float32Type
		]
]

{ #category : #testing }
MbndLiteralNumberType >> isLiteralNumberType [
	^ true
]
