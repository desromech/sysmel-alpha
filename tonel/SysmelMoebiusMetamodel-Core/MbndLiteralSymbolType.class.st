Class {
	#name : #MbndLiteralSymbolType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralSymbolType class >> typeName [
	^ #_LiteralSymbol
]

{ #category : #'testing methods' }
MbndLiteralSymbolType >> isLiteralSymbolType [
	^ true
]
