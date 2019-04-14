Class {
	#name : #MbndLiteralCharacterType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralCharacterType class >> typeName [
	^ #_LiteralCharacter
]

{ #category : #'testing methods' }
MbndLiteralCharacterType >> isLiteralCharacterType [
	^ true
]
