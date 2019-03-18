Class {
	#name : #MbndLiteralSymbolType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralSymbolType class >> typeName [
	^ #_LiteralSymbol
]

{ #category : #'testing methods' }
MbndLiteralSymbolType >> isLiteralSymbolType [
	^ true
]
