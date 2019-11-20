Class {
	#name : #MbndLiteralDictionaryType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralDictionaryType class >> typeName [
	^ #_LiteralDictionary
]

{ #category : #'testing methods' }
MbndLiteralDictionaryType >> isLiteralDictionaryType [
	^ true
]
