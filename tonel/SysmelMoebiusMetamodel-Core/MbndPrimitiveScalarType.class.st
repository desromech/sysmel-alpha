Class {
	#name : #MbndPrimitiveScalarType,
	#superclass : #MbndPrimitiveType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType class >> typeName [
	^ #_PrimitiveScalarType
]

{ #category : #initialization }
MbndPrimitiveScalarType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndArithmeticOperationCoercionMacro new)
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceAlignment [
	<compileTime>
	^ instanceAlignment
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceSize [
	<compileTime>
	^ instanceSize
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceSize: anObject [
	instanceSize := anObject
]

{ #category : #'testing methods' }
MbndPrimitiveScalarType >> isPrimitiveScalarType [
	^ true
]

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType >> primitiveMatrixWithRows: rows columns: columns [
	<compileTime>
	^ self compilationTarget primitiveMatrixTypeFor: self rows: rows columns: columns
	
]

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType >> primitiveVectorWithElements: vectorSize [
	<compileTime>
	^ self compilationTarget primitiveVectorTypeFor: self elements: vectorSize
	
]
