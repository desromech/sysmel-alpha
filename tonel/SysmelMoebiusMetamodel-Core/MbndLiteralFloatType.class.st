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
	| value valueSingleFloat |
	value := literalValueNode value.
	valueSingleFloat := Float fromIEEE32Bit: value asFloat asIEEE32BitWord.
	^ value == valueSingleFloat ifTrue: [ self compilationTarget float32Type ] ifFalse: [ self compilationTarget float64Type ]
]

{ #category : #'testing methods' }
MbndLiteralFloatType >> isLiteralFloatType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralFloatType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope
]
