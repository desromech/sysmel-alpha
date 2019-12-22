Class {
	#name : #MbndPrimitiveMatrixTypeElementConversionRule,
	#superclass : #MbndPrimitiveVectorTypeElementConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndPrimitiveMatrixTypeElementConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	sourceType isPrimitiveVectorType ifFalse: [ ^ false ].
	targetType isPrimitiveMatrixType ifFalse: [ ^ false ].
	sourceType rows = targetType rows ifFalse: [ ^ false ].
	sourceType columns = targetType columns ifFalse: [ ^ false ].
	^ true
]
