Class {
	#name : #MbndLiteralFloatType,
	#superclass : #MbndLiteralNumberType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralFloatType class >> typeName [
	^ #_LiteralFloat
]

{ #category : #converting }
MbndLiteralFloatType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget float64Type
]

{ #category : #'semantic analysis' }
MbndLiteralFloatType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	self flag: 'TODO: Use the number range for selecting this.'.
	^ self compilationTarget float64Type
]

{ #category : #'testing methods' }
MbndLiteralFloatType >> isLiteralFloatType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralFloatType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	self flag: 'TODO: Use the number range for selecting this.'.
	^ self compilationTarget float64Type
]
