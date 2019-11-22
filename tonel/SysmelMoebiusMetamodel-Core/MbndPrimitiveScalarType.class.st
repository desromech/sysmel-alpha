Class {
	#name : #MbndPrimitiveScalarType,
	#superclass : #MbndPrimitiveType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType class >> typeName [
	^ #_PrimitiveScalarType
]

{ #category : #adding }
MbndPrimitiveScalarType >> addArithmeticIntrinsics [
	self addArithmeticIntrinsicsToVectorOrScalarType: self
	
]

{ #category : #adding }
MbndPrimitiveScalarType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	
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
	vectorSize <= 1 ifTrue: [ ^ self ].
	^ self compilationTarget primitiveVectorTypeFor: self elements: vectorSize
	
]
