Class {
	#name : #MbndLiteralCharacterType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralCharacterType class >> typeName [
	^ #_LiteralCharacter
]

{ #category : #'semantic analysis' }
MbndLiteralCharacterType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget int32Type
]

{ #category : #'testing methods' }
MbndLiteralCharacterType >> isLiteralCharacterType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralCharacterType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget int32Type
]
