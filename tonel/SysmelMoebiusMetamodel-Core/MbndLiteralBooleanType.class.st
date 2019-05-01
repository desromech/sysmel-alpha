Class {
	#name : #MbndLiteralBooleanType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanType class >> typeName [
	^ #_LiteralBoolean
]

{ #category : #converting }
MbndLiteralBooleanType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget booleanType
]

{ #category : #'semantic analysis' }
MbndLiteralBooleanType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget booleanType
]

{ #category : #'testing methods' }
MbndLiteralBooleanType >> isLiteralBooleanType [
	^ true
]
