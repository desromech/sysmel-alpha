Class {
	#name : #MbndLiteralBooleanType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanType class >> typeName [
	^ #_LiteralBoolean
]

{ #category : #'semantic analysis' }
MbndLiteralBooleanType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ compilationTarget booleanType
]

{ #category : #'testing methods' }
MbndLiteralBooleanType >> isLiteralBooleanType [
	^ true
]
