Class {
	#name : #MbndLiteralCharacterType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndLiteralCharacterType class >> typeName [
	^ #_LiteralCharacter
]

{ #category : #'testing methods' }
MbndLiteralCharacterType >> isLiteralCharacterType [
	^ true
]
