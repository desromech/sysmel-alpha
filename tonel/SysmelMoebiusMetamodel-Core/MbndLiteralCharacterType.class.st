Class {
	#name : #MbndLiteralCharacterType,
	#superclass : #MbndLiteralIntegerType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralCharacterType class >> typeName [
	^ #_LiteralCharacter
]

{ #category : #converting }
MbndLiteralCharacterType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget managedObjectModel characterClass ifNil: [ super asDynamicObjectTypeForLiteral ]
]

{ #category : #'semantic analysis' }
MbndLiteralCharacterType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	| literalValue |
	literalValue := literalValueNode value asInteger.
	literalValue <= 16rFF ifTrue: [ ^ self compilationTarget char8Type ].
	literalValue <= 16rFFFF ifTrue: [ ^ self compilationTarget char16Type ].
	
	^ self compilationTarget char32Type
]

{ #category : #'testing methods' }
MbndLiteralCharacterType >> isLiteralCharacterType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralCharacterType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget char32Type
]
